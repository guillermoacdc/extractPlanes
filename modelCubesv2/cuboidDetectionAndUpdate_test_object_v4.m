clc
close all 
clear

%% setting parameters
% 0. raw parameters
sessionID=10;
app='_v12';
conditionalAssignationFlag=0;
stopFrameIndex=30;
% 1. Plane filtering parameters
th_angle=18*pi/180;%radians -- actualizado a 18 durante las pruebas de agrupar planos. Valor orignal 15
th_size=150;%number of points
th_lenght=10*10;%mm 10 cm - Update with tolerance_length; is in a high value (30) to pass most of the planes
th_occlusion=1.4;%
D_Tolerance=0.1*1000;%mm ... 0.1 m
planeFilteringParameters=[th_lenght, th_size, th_angle, th_occlusion, D_Tolerance];
% 2. Parameters used in the stage Assesment Pose 
NpointsDiagPpal=20;
tao_v=50;%mm
theta=0.5;
asessmentPoseParameters=[NpointsDiagPpal tao_v];
% 3. Parameteres used in the stage Merging planes between frames
% - used in the function computeTypeOfTwin
tao_merg=50;% mm
theta_merg=0.5;%in percentage
th_IoU=0.2;% percent
th_coplanarDistance=20;%mm
gridStep=1;
mergingPlaneParameters=[tao_merg theta_merg th_IoU th_coplanarDistance gridStep];
% 4. Parameters used in temporal filtering stage
radii=15;%mm - initial value. The raddi changes every time a box is extracted from consolidation zone
windowSize=10;%frames
th_detections=0.3;%percent - not used in version 1 - update with th_vigency
tempFilteringParameters=[radii windowSize th_detections];
% 5. Parameteres used to set the type of planes to process: perpendicular or
% parallel to ground. 
% planeTypes=[0 1];%{0 for parallel to ground, 1 for perpendicular to ground}
% planeTypes=[ 1];
% Npt=size(planeTypes,2);
%6. Parameters to merge pointclouds - used in the approach 2
planeModelParameters(1) =   12;% maxDistance in mm
% 7. compensate factor for perpendicular planes supported on the floor
compensateFactor=0;%mm--- no funcionó como se esperaba. Valor probado: 

% dataSetPath = computeReadPaths(sessionID);
% evalPath = computeReadWritePaths(app);


%% begin Text
disp(['----------Estimating poses in session ' num2str(sessionID) ])
estimatedPose.sessionID=sessionID;
%% unzip parameters
% 1. parameters used to implement the maps-integration strategy
% - used in the function computeTypeOfTwin
tao_merg=mergingPlaneParameters(1);% mm
theta_merg=mergingPlaneParameters(2);%in percentage
gridStep=mergingPlaneParameters(5);
estimatedPose.Parameteres.MergingPlane.tao=tao_merg;
estimatedPose.Parameteres.MergingPlane.theta=theta_merg;
estimatedPose.Parameteres.MergingPlane.gridStep=gridStep;

% 2. parameters to implement the global-map-update strategy 
% radii=tempFilteringParameters(1);%mm - initial value. The raddi changes every time a box is extracted from consolidation zone
windowSize=tempFilteringParameters(2);%frames
th_vigency=tempFilteringParameters(3);%percent - not used in version 1
estimatedPose.Parameteres.Particles.windowSize=windowSize;
estimatedPose.Parameteres.Particles.th_vigency=th_vigency;

%define an empty vector of type particle
particlesVector_temp(1)=particle(1,[0 0 0], 1, 5);
particlesVector_temp(1)=[];
particlesVector.xz=particlesVector_temp;
particlesVector.xy=particlesVector_temp;
particlesVector.zy=particlesVector_temp;


%% Begin processing
% Compute paths to read and write data
% [dataSetPath,evalPath,PCpath] = computeMainPaths(sessionID);
dataSetPath=computeReadPaths(sessionID);
evalPath=computeReadWritePaths(app);
% computing keyframes for the session
keyframes=loadKeyFrames(dataSetPath,sessionID);
estimatedPose.keyFrames=keyframes;
Nframes=length(keyframes);%number of frames
% allocating space for variables
bufferComposedPlanes_temp={};
bufferComposedPlanes.xz=bufferComposedPlanes_temp;
bufferComposedPlanes.xy=bufferComposedPlanes_temp;
bufferComposedPlanes.zy=bufferComposedPlanes_temp;

globalPlanesPrevious=[];
globalPlanes=[];

locaPlanes.xzIndex=[];
locaPlanes.xyIndex=[];
locaPlanes.zyIndex=[];

% loading length bounds
[lengthBoundsTop, lengthBoundsP] =computeLengthBounds_v2(dataSetPath, sessionID);%[L1min L1max L2min L2max]

%% iterative processing
% performing the computation for each frame
% for i=1:Nframes
for i=1:stopFrameIndex
    frameID=keyframes(i);
    disp(['          processing frame ' num2str(frameID) ' - ' num2str(i) '/' num2str(Nframes)])
%     debugg pause
%     if mod(i,20)==0
    if frameID==25
        disp('stop mark')
    end
% First part of update global map stratey: forget old planes-------------
    if mod(i,windowSize)==0 %& i>=2*windowSize
        if (i-windowSize)>=1
            windowInit=keyframes(i-windowSize);
        else
            windowInit=keyframes(1);
        end
        [globalPlanes, particlesVector] =updatePresence_vcuboids(globalPlanes,particlesVector,windowInit,...
            keyframes(1), th_vigency);
    end

%     compute radii to manage particles-------------
    radii=computeRaddi_v2(dataSetPath,sessionID,frameID);
%   detect and filter plane segments
%     tic;
    [localPlanes,Nnap] = detectAndFilterPlaneSegments_vcuboids(sessionID,frameID, planeFilteringParameters, compensateFactor);
%%     save estimations
    if ~isempty(localPlanes.values)

%   Second part of the update global map strategy: update particle----
%         vector
        particlesVector = updateParticleVector_vcuboids(localPlanes,...
                    particlesVector, radii, frameID);
% update globalPlanesPrevious vector--------------        
        if isempty(globalPlanesPrevious)
            globalPlanesPrevious=clonePlaneObject_vcuboids(localPlanes);%h-world
        else
            globalPlanesPrevious=clonePlaneObject_vcuboids(globalPlanes);
        end
% First part of maps integration: integrat local with global planes
% previous
% integration btwn top planes
%     if size top-localPlanes > 1 then integrate
% integration btwn perpendicular planes
%     if size perpendicular localPlanes >1 then integrate
        [globalPlanes, bufferComposedPlanes]=mergeIntoGlobalPlanes_vcuboids(localPlanes,...
            globalPlanesPrevious,tao_merg,theta_merg, lengthBoundsTop,...
            lengthBoundsP,bufferComposedPlanes, planeFilteringParameters, planeModelParameters, gridStep, compensateFactor);%h-world
% Third part of update global map strategy: associat particles with global
% planes
        globalPlanes = associateParticlesWithGlobalPlanes_vcuboids(globalPlanes,particlesVector, radii);
    

        [globalPlanes, bufferComposedPlanes] = performMergeSingleMap_vcuboid(globalPlanes,tao_merg, theta_merg, ...
            th_coplanarDistance, planeFilteringParameters, planeModelParameters, ...
            lengthBoundsTop, gridStep, lengthBoundsP, compensateFactor, bufferComposedPlanes);
        
        [group_tpp, group_tp, group_s]=firstGrouping(globalPlanes, ...
        th_angle, conditionalAssignationFlag);
%% compute boxes from groups of triads
        Ng=length(group_tpp);
        if Ng>1
            for i_box=1:Ng
                splane=globalPlanes.values(group_tpp(i_box));
                secondIndex=splane.secondPlaneID;
                thirdIndex=splane.thirdPlaneID;
                triadID=[splane.getID(), globalPlanes.values(secondIndex).getID, globalPlanes.values(thirdIndex).getID];
                disp(['          splane ' num2str(triadID(1)) '-' num2str(triadID(2))...
                    ' is associated with splane ' num2str(triadID(3)) '-' num2str(triadID(4)),...
                    ' and splane ' num2str(triadID(5)) '-' num2str(triadID(6))])
%                 boxID=i_box;
                triadIndex=[group_tpp(i_box), secondIndex thirdIndex];
                globalBoxes(i_box)=createBoxObject_vcuboids(globalPlanes.values,triadIndex, sessionID, frameID); 
            end
        end

        % complement estimated pose and save        
%         estimatedPose.(['frame' num2str(frameID)])=mystruct(globalPlanes);  
%         estimatedPose.(['frame' num2str(frameID)]).values=obj2struct_vector(globalPlanes); 
        %     additional properties of estimatedPose (Nnap, processingTime)
%         estimatedPose.(['frame' num2str(frameID)]).Nnap=Nnap;
    else
%         estimatedPose.(['frame' num2str(frameID)])=[];
    end
end

myDisplayGroups(globalPlanes.values, group_tpp, group_tp, group_s);
% figure,
% myPlotEstimatedBox(globalPlanes,globalBoxes,sessionID,frameID);
figure,
syntheticPlaneType=4;
plotEstimationsByFrame_vcuboids_2(globalPlanes.values,syntheticPlaneType,...
    dataSetPath,sessionID,frameID)


figure,
    myPlotPlanes_v3(localPlanes.values,1);
    title(['local planes  in frame ' num2str(frameID-1)])

figure,
    myPlotPlanes_v3(globalPlanes.values,1);
    title(['global planes  previous in frame ' num2str(frameID-1)])

% removing warnings
w = warning('query','last');
id=w.identifier;
warning('off',id)




% %% first version
% 
% inputFileName=['estimatedPoses_ia_planeType' num2str(0) '.json'];
% estimatedPoses0 = loadEstimationsFile(inputFileName,sessionID, evalPath);
% inputFileName=['estimatedPoses_ia_planeType' num2str(1) '.json'];
% estimatedPoses1 = loadEstimationsFile(inputFileName,sessionID, evalPath);
% 
% 
% %% load global Planes
% globalPlanes=loadGlobalPlanesFromFrame(estimatedPoses0,estimatedPoses1,frameID);

%         [globalPlanes,bufferComposedPlanes]=mergePlanesOfASingleFrame_v2(globalPlanes, ...
%              bufferComposedPlanes,planeFilteringParameters,...
%             lengthBoundsTop, lengthBoundsP, planeModelParameters, gridStep, compensateFactor)

