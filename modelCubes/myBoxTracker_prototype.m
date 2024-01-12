function [estimatedBoxPose, estimatedPlanePose]=myBoxTracker_v3(sessionID, ...
    planeFilteringParameters, ...
            mergingPlaneParameters, tempFilteringParameters, ...
            planeModelParameters, compensateFactor, app)
% MYBOXTRACKER  Tracks the pose of boxes in consolidation zone
% The outputs are writed on disk in the file outputFileName.csv
% The inputs
%   sessionID, 
%   outputFileName, 
%   planeFilteringParameters: parameters used to filter planes
%           planeFilteringParameters=[th_lenght, th_size, th_angle, th_occlusion, D_Tolerance];
%   mergingPlaneParameters: parameters used to implement the maps-integration strategy
%           mergingPlaneParameters=[tao_merg theta_merg th_IoU th_coplanarDistance gridStep];
%   tempFilteringParameters: parameters to implement the global-map-update strategy 
%           tempFilteringParameters=[radii windowSize th_detections];
%   planeModelParameters. ? 
%   compensateFactor. To compensate the elimination of points that belong 
%   to boxes and are near to the ground plane
%   ground

%% unzip parameters
% 1. parameters used to implement the maps-integration strategy
% - used in the function computeTypeOfTwin
tao_merg=mergingPlaneParameters(1);% mm
theta_merg=mergingPlaneParameters(2);%in percentage
gridStep=mergingPlaneParameters(5);
th_coplanarDistance=mergingPlaneParameters(4);
estimatedBoxPose.Parameteres.MergingPlane.tao=tao_merg;
estimatedBoxPose.Parameteres.MergingPlane.theta=theta_merg;
estimatedBoxPose.Parameteres.MergingPlane.gridStep=gridStep;
estimatedPlanePose.Parameteres.MergingPlane.tao=tao_merg;
estimatedPlanePose.Parameteres.MergingPlane.theta=theta_merg;
estimatedPlanePose.Parameteres.MergingPlane.gridStep=gridStep;
% 2. parameters to implement the global-map-update strategy 
% radii=tempFilteringParameters(1);%mm - initial value. The raddi changes every time a box is extracted from consolidation zone
windowSize=tempFilteringParameters(2);%frames
th_vigency=tempFilteringParameters(3);%percent - not used in version 1
estimatedBoxPose.Parameteres.Particles.windowSize=windowSize;
estimatedBoxPose.Parameteres.Particles.th_vigency=th_vigency;
estimatedPlanePose.Parameteres.Particles.windowSize=windowSize;
estimatedPlanePose.Parameteres.Particles.th_vigency=th_vigency;
% 3 parameters used to filter planes
th_angle=planeFilteringParameters(1);

conditionalAssignationFlag=0;
%% begin Text
disp(['----------Estimating poses in session ' num2str(sessionID) ])
estimatedBoxPose.sessionID=sessionID;
estimatedPlanePose.sessionID=sessionID;


%% Begin processing
% Compute paths to read and write data
dataSetPath=computeReadPaths(sessionID);

% computing keyframes for the session
keyframes=loadKeyFrames(dataSetPath,sessionID);
estimatedBoxPose.keyFrames=keyframes;
estimatedPlanePose.keyFrames=keyframes;
Nframes=length(keyframes);%number of frames
% allocating space for variables
bufferComposedPlanes_temp={};
bufferComposedPlanes.xz=bufferComposedPlanes_temp;
bufferComposedPlanes.xy=bufferComposedPlanes_temp;
bufferComposedPlanes.zy=bufferComposedPlanes_temp;

% globalPlanesPrevious=[];
globalPlanesPrevious.values=[];
globalPlanesPrevious.xzIndex=[];
globalPlanesPrevious.xyIndex=[];
globalPlanesPrevious.zyIndex=[];

% globalPlanes=[];
globalPlanes.values=[];
globalPlanes.xzIndex=[];
globalPlanes.xyIndex=[];
globalPlanes.zyIndex=[];

localPlanes.xzIndex=[];
localPlanes.xyIndex=[];
localPlanes.zyIndex=[];
%define an empty vector of type particle
particlesVector_temp(1)=particle(1,[0 0 0], 1, 5);
particlesVector_temp(1)=[];
particlesVector.xz=particlesVector_temp;
particlesVector.xy=particlesVector_temp;
particlesVector.zy=particlesVector_temp;
% loading length bounds
[lengthBoundsTop, lengthBoundsP] =computeLengthBounds_v2(dataSetPath, sessionID);%[L1min L1max L2min L2max]

%% iterative processing
% performing the computation for each frame
for i=1:Nframes
% for i=1:20
    frameID=keyframes(i);
    disp(['          processing frame ' num2str(frameID) ' - ' num2str(i) '/' num2str(Nframes)])

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

% First part of maps integration: integrat local with global planes
% previous
% integration btwn top planes
%     if size top-localPlanes > 1 then integrate
% integration btwn perpendicular planes
%     if size perpendicular localPlanes >1 then integrate
        [globalPlanes, bufferComposedPlanes]=mergeIntoGlobalPlanes_vcuboids(localPlanes,...
            globalPlanesPrevious,tao_merg,theta_merg, lengthBoundsTop,...
            lengthBoundsP,bufferComposedPlanes, planeFilteringParameters, planeModelParameters, gridStep, compensateFactor);%h-world
        [globalPlanes, bufferComposedPlanes] = performMergeSingleMap_vcuboid(globalPlanes,tao_merg, theta_merg, ...
            th_coplanarDistance, planeFilteringParameters, planeModelParameters, ...
            lengthBoundsTop, gridStep, lengthBoundsP, compensateFactor, bufferComposedPlanes);
% Third part of update global map strategy: associat particles with global
% planes
        globalPlanes = associateParticlesWithGlobalPlanes_vcuboids(globalPlanes,particlesVector, radii);
        % ----------debug
%         if mod(i,10)==0
        if frameID==91
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
%    conform Boxes
        [group_tpp, group_tp, group_s]=firstGrouping(globalPlanes, ...
        th_angle, conditionalAssignationFlag);
        globalBoxes=computeBoxesFromGroups(globalPlanes,group_tpp, group_tp, group_s, sessionID, frameID);
      
        % update globalPlanesPrevious vector--------------        
        if isempty(globalPlanesPrevious)
            globalPlanesPrevious=clonePlaneObject_vcuboids(localPlanes);%h-world
        else
            globalPlanesPrevious=clonePlaneObject_vcuboids(globalPlanes);
        end

    else
        if ~isempty(globalPlanesPrevious.values)
            Nnap=0;
            globalPlanes=[];
            globalPlanes=clonePlaneObject(globalPlanesPrevious.values);
        else
            globalPlanes=[];
            globalBoxes=[];
        end
%         estimatedBoxPose.(['frame' num2str(frameID)])=[];
%         estimatedPlanePose.(['frame' num2str(frameID)])=[];
    end
        % complement estimated pose and save        
    estimatedBoxPose.(['frame' num2str(frameID)]).values=obj2struct_vector(globalBoxes); 
    estimatedBoxPose.(['frame' num2str(frameID)]).Nnap=Nnap;
    estimatedPlanePose.(['frame' num2str(frameID)]).values=obj2struct_vector(globalPlanes); 
    estimatedPlanePose.(['frame' num2str(frameID)]).Nnap=Nnap;
end

myDisplayGroups(globalPlanes.values, group_tpp, group_tp, group_s);
% figure,
% myPlotEstimatedBox(globalPlanes,globalBoxes,sessionID,frameID);
figure,
syntheticPlaneType=4;
plotEstimationsByFrame_vcuboids_2(globalPlanes.values,syntheticPlaneType,...
    dataSetPath,sessionID,frameID)
fc='b';
figure,
    myPlotBoxContour_v2(globalBoxes,sessionID,frameID,fc)


figure,
    myPlotPlanes_v3(localPlanes.values,1);
    title(['local planes  in frame ' num2str(frameID-1)])


% removing warnings
w = warning('query','last');
id=w.identifier;
warning('off',id)

end


