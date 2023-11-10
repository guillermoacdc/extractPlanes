function  myPlaneTracker_v2(sessionID, outputFileName, planeFilteringParameters, ...
            mergingPlaneParameters, tempFilteringParameters, ...
            planeType, planeModelParameters, compensateFactor, app)
%MYPLANETRACKER Tracks the pose of planes that belong to boxes
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
%   planeType: 0 for top planes, 1 for perpendicular planes to ground 
%   planeModelParameters. ? 
%   compensateFactor. To compensate the elimination of points that belong 
%   to boxes and are near to the ground plane
%   ground

%% begin Text
disp(['----------Estimating poses in session ' num2str(sessionID) ' with plane type ' num2str(planeType)])
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
particlesVector(1)=particle(1,[0 0 0], 1, 5);
particlesVector(1)=[];

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
bufferComposedPlanes={};
globalPlanesPrevious=[];
globalPlanes=[];
localPlanes=[];
% loading length bounds
[lengthBoundsTop, lengthBoundsP] =computeLengthBounds_v2(dataSetPath, sessionID);%[L1min L1max L2min L2max]

%% iterative processing
% performing the computation for each frame
for i=1:Nframes
%% intro
    frameID=keyframes(i);
%     compute radii to manage particles-------------
    radii=computeRaddi_v2(dataSetPath,sessionID,frameID);

    disp(['          processing frame ' num2str(frameID) ' - ' num2str(i) '/' num2str(Nframes)])
%     debugg pause
%     if mod(i,10)==0
    if frameID==85
        disp('stop mark')
    end
%% planeDetector + plane segment detector + filtering
%   detect and filter plane segments
    [localPlanes,Nnap] = detectAndFilterPlaneSegments_vcuboids(sessionID,...
        frameID, planeFilteringParameters, compensateFactor);
% init globalPlanesPrevious
    if i==1
        globalPlanesPrevious=clonePlaneObject(localPlanes.values);%h-world
    end
%% conform a global map of planes
    if ~isempty(localPlanes)
% First part of search and join of commons: search btwn local and global planes
% previous
        [globalPlanes, bufferComposedPlanes]=mergeIntoGlobalPlanes_v3(localPlanes,...
            globalPlanesPrevious,tao_merg,theta_merg, lengthBoundsTop,...
            lengthBoundsP,bufferComposedPlanes, planeFilteringParameters, planeModelParameters, gridStep, compensateFactor);%h-world
% Second part of search and join commons:search btwn elements of global
% Planes
        [globalPlanes, bufferComposedPlanes] = performMergeSingleMap_vcuboid(globalPlanes,tao_merg, theta_merg, ...
            th_coplanarDistance, planeFilteringParameters, planeModelParameters, ...
            lengthBoundsTop, gridStep, lengthBoundsP, compensateFactor, bufferComposedPlanes);
%% particles management
% initialization of particles and update of particles's properties 
        particlesVector = updateParticleVector(localPlanes,...
                    particlesVector, radii, frameID);
% associate particles with global planes
        globalPlanes = associateParticlesWithGlobalPlanes(globalPlanes,particlesVector, radii);
% elimination of particles and plane segments that loose vigency
        if mod(i,windowSize)==0 %& i>=2*windowSize
            if (i-windowSize)>=1
                windowInit=keyframes(i-windowSize);
            else
                windowInit=keyframes(1);
            end
            [globalPlanes, particlesVector] =updatePresence_v3(globalPlanes,particlesVector,windowInit,...
                keyframes(1), th_vigency);
        end
        % update previous global map
        globalPlanesPrevious=clonePlaneObject(globalPlanes);

    else
       if ~isempty(globalPlanesPrevious.values)
            Nnap=0;
            globalPlanes=[];
            globalPlanes=clonePlaneObject(globalPlanesPrevious.values);
        else
            globalPlanes=[];
            globalBoxes=[];
        end
    end
end

% write json file to disk
% estimatedPose_s=struct(estimatedPose);
mySaveStruct2JSONFile(estimatedPose,outputFileName,evalPath,sessionID);
figure,
    myPlotPlanes_v3(localPlanes,1);
    title(['local planes  in frame ' num2str(frameID)])

figure,
    plotEstimationsByFrame;%script

end

