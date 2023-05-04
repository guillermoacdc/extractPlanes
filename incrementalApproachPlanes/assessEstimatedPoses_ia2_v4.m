% Second version of an incremental approach. In the merge stage performs a
% a hybrid strategy which includes: (1) selection of planes or (2) creation 
% of new planes. The second strategy includes (1)  creation of a new point 
% cloud through fusion of two or more point clouds, (2) the processment of 
% the new pc to compute the plane properties, (3) the managmente of a
% buffer to keep the record of components in new pointclouds/planes, (4)
% the delete of components in global planes after a time window
% First version of temporalPlanesFiltering
clc
close all
clear

sessionID=1;
[dataSetPath,evalPath,PCpath] = computeMainPaths(sessionID);
fileName='estimatedPoses_ia2.json';

planeType=0;%{0 for xzPlanes, 1 for xyPlanes, 2 for zyPlanes} in qh_c coordinate system
%% parameters 2. Plane filtering (based on previous knowledge) and pose/length estimation. 
th_angle=15*pi/180;%radians
th_size=150;%number of points
th_lenght=10*10;%mm 10 cm - Update with tolerance_length; is in a high value (30) to pass most of the planes
th_occlusion=1.4;%
D_Tolerance=0.1*1000;%mm ... 0.1 m
tresholdsV=[th_lenght, th_size, th_angle, th_occlusion, D_Tolerance];
%% parameters 3.  Assesment Pose with e_ADD
tao_v=10:10:50;
NpointsDiagPpal=20;
%% parameters 4. Merging planes between frames
% parameters of merging planes - used in the function computeTypeOfTwin
tao_merg=50;% mm
theta_merg=0.5;%in percentage
%% parameters of temporal filtering
%define an empty vector of type particle
% particlesVector(1)=particle(1,[0 0 0], 100, 150, 5);
particlesVector(1)=particle(1,[0 0 0], 1, 5);
particlesVector(1)=[];
radii=computeRaddi(dataSetPath,sessionID,1,planeType)/2;
% radii=50;%mm
windowSize=15;%frames
th_detections=0.3;%percent - not used in version 1

%% parameters 5. To compute the plane model from the new pointclouds
planeModelParameters(1) =   12;% maxDistance in mm
planeModelParameters(2) =   5;%maxAngularDistance in deg
switch planeType
    case 0
        planeModelParameters(3:5) =   [0 1 0];%referenceNormal for xzPlanes
    case 1
        planeModelParameters(3:5) =   [0 0 1];%referenceNormal for xyPlanes
    case 2
        planeModelParameters(3:5) =   [1 0 0];%referenceNormal for zyPlanes
end



%% processing
% computing keyframes for the session
keyframes=loadKeyFrames(dataSetPath,sessionID);

Nframes=length(keyframes);
Ntao=length(tao_v);

% performing the computation for each frame
estimatedPoses.tao=tao_v;
globalPlanesPrevious=[];
bufferComposedPlanes={};
[lengthBoundsTop, lengthBoundsP] =computeLengthBounds_v2(dataSetPath, sessionID);%[L1min L1max L2min L2max]


for i=1:Nframes
% for i=8:24
    frameID=keyframes(i);
%     radii=computeRaddi(dataSetPath,sessionID,frameID,planeType );
    logtxt=['Assessing detections in frame ' num2str(frameID) '; i=' num2str(i) ', radii=' num2str(radii) 'mm'];
    disp(logtxt);
    if i==39
        disp('control point from assessEstimatedPoses_ia2')
    end
%     writeProcessingState(logtxt,evalPath,sessionID);
%% load initial pose and extract raw planes from the current frame
    gtPoses=loadInitialPose(dataSetPath,sessionID,frameID);
    estimatedPlanesfr=loadExtractedPlanes(dataSetPath,sessionID,frameID,...
        PCpath, tresholdsV);%returns a struct with a property frx - h world
%% extract target identifiers based on type of plane
    estimatedPlanesID=extractTargetIDs(estimatedPlanesfr,frameID,planeType);

%% forget old planes
    if mod(i,windowSize)==0 %& i>=2*windowSize
        [globalPlanes, particlesVector]=updatePresence(globalPlanes,...
                particlesVector,windowSize, frameID,keyframes(1));
    end
%% processing target identifiers in form of vectors
% fill estimatedPoses output
    if isempty(estimatedPlanesID)
        estimatedPoses.(['frame' num2str(frameID)])=[];%empty frames are frames where detections were null
        continue
    else
% convert struct to vector localPlanes
        localPlanes=loadPlanesFromIDs(estimatedPlanesfr,estimatedPlanesID);%vector in h world
% merge between planes of localPlanes - type 4        
        [localPlanes,bufferComposedPlanes]=mergePlanesOfASingleFrame_v2(localPlanes,bufferComposedPlanes,tresholdsV,...
            lengthBoundsTop, lengthBoundsP, planeModelParameters);%

% update globalPlanesPrevious vector        
        if isempty(globalPlanesPrevious)
            globalPlanesPrevious=clonePlaneObject(localPlanes);%h-world
        else
            globalPlanesPrevious=clonePlaneObject(globalPlanes);
        end
% merge between local and globalPlanesPrevious. Types 1 to 4
        [globalPlanes, bufferComposedPlanes]=mergeIntoGlobalPlanes_v3(localPlanes,...
            globalPlanesPrevious,tao_merg,theta_merg, lengthBoundsTop,...
            lengthBoundsP,bufferComposedPlanes, tresholdsV, planeModelParameters);%h-world
% merge between planes of globalPlanes - type 4
         [globalPlanes,bufferComposedPlanes]=mergePlanesOfASingleFrame_v2(globalPlanes,bufferComposedPlanes,tresholdsV,...
            lengthBoundsTop, lengthBoundsP, planeModelParameters);%       
%% temporal filtering
% compute presence of a particle using localPlanes
particlesVector = computeParticlesVector(localPlanes,...
            particlesVector, radii, frameID);
% associate particles with global planes
globalPlanes = associateParticlesWithGlobalPlanes(globalPlanes,particlesVector, radii);


%% assess estimated poses

% project estimated poses to qm and compute estimatedPoses struct. The rest of properties is kept
%         globalPlanes_t=clonePlaneObject(globalPlanes);
%         estimatedGlobalPlanesID=extractIDsFromVector(globalPlanes_t);
%         estimatedPoses=computeEstimatedPosesStruct(globalPlanes_t,gtPoses,...
%             sessionID,frameID,estimatedGlobalPlanesID,tao_v,evalPath,dataSetPath,...
%             NpointsDiagPpal,estimatedPoses);

    end

%     
end


return
% write json file to disk
mySaveStruct2JSONFile(estimatedPoses,fileName,evalPath,sessionID);

% figure,
%     myPlotPlanes_v2(estimatedPlanesfr,estimatedPlanesfr.fr27.acceptedPlanes,0);
%     title(['local planes in frame ' num2str(frameID)])
%     hold on
%     dibujarsistemaref(eye(4),'m',150,2,10,'w');
    

figure,
    myPlotPlanes_v3(localPlanes,0);
    title(['local planes in frame ' num2str(frameID)])

figure,
    myPlotPlanes_v3(globalPlanes,0);
    title(['global planes  in frame ' num2str(frameID)])

figure,
    hold on
    myPlotPlanes_v3(globalPlanesPrevious,0);
    title(['global planes  previous in frame ' num2str(frameID)])

% removing warnings
w = warning('query','last');
id=w.identifier;
warning('off',id)
