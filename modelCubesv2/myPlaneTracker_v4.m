function [estimatedPlanePose]=myPlaneTracker_v4(sessionID, ...
    planeFilteringParameters, ...
            mergingPlaneParameters, tempFilteringParameters, ...
            planeModelParameters, compensateFactor)
% MYPLANETRACKER  Tracks the pose of planes in consolidation zone
% The outputs are returned in the struct estimatedPlanePose 
% The inputs
%   sessionID, 
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

estimatedPlanePose.Parameteres.MergingPlane.tao=tao_merg;
estimatedPlanePose.Parameteres.MergingPlane.theta=theta_merg;
estimatedPlanePose.Parameteres.MergingPlane.gridStep=gridStep;
% 2. parameters to implement the global-map-update strategy 
% radii=tempFilteringParameters(1);%mm - initial value. The raddi changes every time a box is extracted from consolidation zone
windowSize=tempFilteringParameters(2);%frames
th_vigency=tempFilteringParameters(3);%percent - not used in version 1
estimatedPlanePose.Parameteres.Particles.windowSize=windowSize;
estimatedPlanePose.Parameteres.Particles.th_vigency=th_vigency;
% 3 parameters used to filter planes
th_angle=planeFilteringParameters(1);
%  - used in the function mySetFitnessPlane.m
th_distance_depthCamera=[planeFilteringParameters(6), planeFilteringParameters(7)];
estimatedPlanePose.Parameteres.DepthCamera_range=th_distance_depthCamera;
conditionalAssignationFlag=0;
%% begin Text
disp(['----------Estimating poses in session ' num2str(sessionID) ])
estimatedPlanePose.sessionID=sessionID;


%% Initilize vars
% Compute paths to read and write data
dataSetPath=computeReadPaths(sessionID);

% computing keyframes for the session
keyframes=loadKeyFrames(dataSetPath,sessionID);

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
    %% intro
    frameID=keyframes(i);
    disp(['          processing frame ' num2str(frameID) ' - ' num2str(i) '/' num2str(Nframes)])
    %     compute radii to manage particles-------------
    radii=computeRaddi_v2(dataSetPath,sessionID,frameID);
    %% planeDetector + plane segment detector + filtering
    %   detect and filter plane segments
    %     tic;
    [localPlanes,Nnap] = detectAndFilterPlaneSegments_vcuboids(sessionID,...
        frameID, planeFilteringParameters, compensateFactor);
    % init globalPlanesPrevious
    if i==1
        globalPlanesPrevious=clonePlaneObject_vcuboids(localPlanes);%h-world
    end
    %% conform a global map of planes
    if ~isempty(localPlanes.values)
        % First part of search and join of commons: search btwn local and global planes
        % previous
        [globalPlanes, bufferComposedPlanes]=mergeIntoGlobalPlanes_vcuboids(localPlanes,...
            globalPlanesPrevious,tao_merg,theta_merg, lengthBoundsTop,...
            lengthBoundsP,bufferComposedPlanes, planeFilteringParameters, planeModelParameters, gridStep, compensateFactor);%h-world
        % Second part of search and join commons:search btwn elements of global
        % Planes        
        [globalPlanes, bufferComposedPlanes] = performMergeSingleMap_vcuboid(globalPlanes,tao_merg, theta_merg, ...
            th_coplanarDistance, planeFilteringParameters, planeModelParameters, ...
            lengthBoundsTop, gridStep, lengthBoundsP, compensateFactor, bufferComposedPlanes);
        %% particles management
        % initialization of particles and update of particles's properties 
        particlesVector = updateParticleVector_vcuboids(localPlanes,...
                    particlesVector, radii, frameID);
        % associate particles with global planes
        globalPlanes = associateParticlesWithGlobalPlanes_vcuboids(globalPlanes,particlesVector, radii);
        % ----------debug
%         if mod(i,10)==0
        if frameID==25
            disp('stop mark')
        end 
%         idGP=extractIDsFromVector(globalPlanes.values);
%         idGP_zero=find(idGP(:,1)==0);
%         if ~isempty(idGP_zero)
%              disp('stop mark')
%         end
%         fitness=extractFitnessFromVector(localPlanes.values);
%         indexFitness=find(fitness>0);
%         if ~isempty(indexFitness)
%              disp('stop mark')
%         end
%         dco_mean(i)=mean(extractDistanceCameraFromVector(localPlanes.values));
%         dco_std(i)=std(extractDistanceCameraFromVector(localPlanes.values));
%         dco_min(i)=min(extractDistanceCameraFromVector(localPlanes.values));
%         dco_maxn(i)=max(extractDistanceCameraFromVector(localPlanes.values));
        % ------------------
        % elimination of particles and plane segments that loose vigency
        if mod(i,windowSize)==0 %& i>=2*windowSize
            if (i-windowSize)>=1
                windowInit=keyframes(i-windowSize);
            else
                windowInit=keyframes(1);
            end
            [globalPlanes, particlesVector] =updatePresence_vcuboids(globalPlanes,particlesVector,windowInit,...
                keyframes(1), th_vigency);
        end
        % update previous global map
        globalPlanesPrevious=clonePlaneObject_vcuboids(globalPlanes);      


    else
        if ~isempty(globalPlanesPrevious.values)
            Nnap=0;
            globalPlanes=[];
            globalPlanes=clonePlaneObject_vcuboids(globalPlanesPrevious);
        else
            globalPlanes=[];
            globalBoxes=[];
        end

    end
        % complement estimated pose and save        
%     estimatedPlanePose.(['frame' num2str(frameID)]).values=obj2struct_vector(globalPlanes); 
    estimatedPlanePose.(['frame' num2str(frameID)]).values=obj2struct(globalPlanes); 
    estimatedPlanePose.(['frame' num2str(frameID)]).Nnap=Nnap;
end
evalPath=computeReadWritePaths('_vdebug');
recordDescriptors(dataSetPath, sessionID, frameID, globalPlanes,localPlanes, evalPath)

figure,
syntheticPlaneType=4;
plotEstimationsByFrame_vcuboids_2(globalPlanes.values,syntheticPlaneType,...
    dataSetPath,sessionID,frameID)
% 
figure,
    myPlotPlanes_v3(localPlanes.values,1);
    title(['local planes  in frame ' num2str(frameID-1)])


% removing warnings
w = warning('query','last');
id=w.identifier;
warning('off',id)

% % planes that disappear
% A=extractIDsFromVector(globalPlanesPrevious.values);
% B=extractIDsFromVector(globalPlanes.values);
% C=mySetDiff_2D(A,B)

end


