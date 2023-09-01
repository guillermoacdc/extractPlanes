function estimatePoses_ia2_v2(sessionID, fileName, planeFilteringParameters, ...
            mergingPlaneParameters, tempFilteringParameters, ...
            planeType, planeModelParameters)
% ESTIMATEPOSES_IA2_v2() Second version of an incremental approach. In the 
% merge stage performs a % a hybrid strategy which includes: (1) selection 
% of planes or (2) creation of new planes. The second strategy includes (1)  
% creation of a new point cloud through fusion of two or more point 
% clouds, (2) the processment of the new pc to compute the plane 
% properties, (3) the managment of a buffer to keep the record of 
% components in new pointclouds/planes, (4) the delete of components in 
% global planes after a time window. First version of temporalPlanesFiltering
%_v2: implements a version that save estimated poses in qh world
disp(['----------computing performance in session ' num2str(sessionID) ' under incremental algorithm'])
%% unzip parameters
% 2. Parameters used in the stage Assesment Pose 
% NpointsDiagPpal=asessmentPoseParameters(1);
% tao_v=asessmentPoseParameters(2);%mm

% 3. Parameteres used in the stage Merging planes between frames
% - used in the function computeTypeOfTwin
tao_merg=mergingPlaneParameters(1);% mm
theta_merg=mergingPlaneParameters(2);%in percentage

% 4. Parameters used in temporal filtering stage
% radii=tempFilteringParameters(1);%mm - initial value. The raddi changes every time a box is extracted from consolidation zone
windowSize=tempFilteringParameters(2);%frames
th_vigency=tempFilteringParameters(3);%percent - not used in version 1
%define an empty vector of type particle
particlesVector(1)=particle(1,[0 0 0], 1, 5);
particlesVector(1)=[];

% 5. Parameteres used to set the type of planes to process: perpendicular or
% parallel to ground. {0 for parallel to ground, 1 for perpendicular to ground}
% (a) syntheticPlaneType {0 for top planes, 1 for front and back planes, 
% 2 for right and left planes, 3 for [front right, back, and left planes]}
% (b) estimatedPlaneType {0 for xzPlanes, 1 for xyPlanes, 2 for zyPlanes, 
% 3 for [zyPlanes; zyPlanes]} in qh_c coordinate system

if planeType==0
    % For top planes use
%     syntheticPlaneType=0;
    estimatedPlaneType=0;
else
    % For perpendicular planes use
%     syntheticPlaneType=3;
    estimatedPlaneType=3;
end

% 6. paths to read and write data
[dataSetPath,evalPath,PCpath] = computeMainPaths(sessionID);

%% processing
% computing keyframes for the session
keyframes=loadKeyFrames(dataSetPath,sessionID);
Nframes=length(keyframes);
% allocating space for variables
bufferComposedPlanes={};
globalPlanesPrevious=[];
globalPlanes=[];
localPlanes=[];
% loading length bounds
[lengthBoundsTop, lengthBoundsP] =computeLengthBounds_v2(dataSetPath, sessionID);%[L1min L1max L2min L2max]

% performing the computation for each frame
for i=1:Nframes
    if mod(i,50)==0
        disp('stop mark')
    end
    tic;
    frameID=keyframes(i);
    radii=computeRaddi(dataSetPath,sessionID,frameID,estimatedPlaneType );
    logtxt=['Assessing detections in frame ' num2str(frameID) ', radii=' num2str(radii) 'mm. i=' num2str(i) '/' num2str(length(keyframes))];
    disp(logtxt);
%% load initial pose and extract raw planes from the current frame
    estimatedPlanesfr=loadExtractedPlanes(dataSetPath,sessionID,frameID,...
        PCpath, planeFilteringParameters);%returns a struct with a property frx - h world
%     compute number of non accepted planes by local frame
    Nnap=size(estimatedPlanesfr.(['fr' num2str(frameID)]).values,2)-size(estimatedPlanesfr.(['fr' num2str(frameID)]).acceptedPlanes,1);
    estimatedPoses.(['frame' num2str(frameID)]).Nnap=Nnap;    %

%% extract target identifiers based on type of plane
    estimatedPlanesID=extractTargetIDs(estimatedPlanesfr,frameID,estimatedPlaneType);

%% forget old planes
        if mod(i,windowSize)==0 %& i>=2*windowSize
            if (i-windowSize)>=1
                windowInit=keyframes(i-windowSize);
            else
                windowInit=keyframes(1);
            end
%             globalPlanes=updatePresence_v4(globalPlanes,particlesVector,windowInit, keyframes(1), th_vigency);
            [globalPlanes, particlesVector] =updatePresence_v3(globalPlanes,particlesVector,windowInit,...
    keyframes(1), th_vigency);
        end
%% processing target identifiers in form of vectors
% fill estimatedPoses output
    if isempty(estimatedPlanesID)
        estimatedPoses.(['frame' num2str(frameID)])=[];%empty frames are frames where detections were null
        toc;%no se registra el tiempo de procesamiento para frames que no detectan planos
    else
% convert struct to vector localPlanes
        localPlanes=loadPlanesFromIDs(estimatedPlanesfr,estimatedPlanesID);%vector in h world
% merge between planes of localPlanes - type 4        
        [localPlanes,bufferComposedPlanes]=mergePlanesOfASingleFrame_v2(localPlanes, ...
            bufferComposedPlanes,planeFilteringParameters,...
            lengthBoundsTop, lengthBoundsP, planeModelParameters);%
% compute presence of a particle using localPlanes
        particlesVector = updateParticleVector(localPlanes,...
                    particlesVector, radii, frameID);
% update globalPlanesPrevious vector        
        if isempty(globalPlanesPrevious)
            globalPlanesPrevious=clonePlaneObject(localPlanes);%h-world
        else
            globalPlanesPrevious=clonePlaneObject(globalPlanes);
        end
% merge between local and globalPlanesPrevious. Types 1 to 4
        [globalPlanes, bufferComposedPlanes]=mergeIntoGlobalPlanes_v3(localPlanes,...
            globalPlanesPrevious,tao_merg,theta_merg, lengthBoundsTop,...
            lengthBoundsP,bufferComposedPlanes, planeFilteringParameters, planeModelParameters);%h-world
% merge between planes of globalPlanes - type 4
         [globalPlanes,bufferComposedPlanes]=mergePlanesOfASingleFrame_v2(globalPlanes, ...
             bufferComposedPlanes,planeFilteringParameters,...
            lengthBoundsTop, lengthBoundsP, planeModelParameters);%       
%% temporal filtering

% associate particles with global planes
globalPlanes = associateParticlesWithGlobalPlanes(globalPlanes,particlesVector, radii);

%% save estimated poses
ProcessingTime=toc;
        estimatedGlobalPlanesID=extractIDsFromVector(globalPlanes);
        estimatedPoses=computeEstimatedPosesStruct_qh(globalPlanes,...
            frameID,estimatedGlobalPlanesID,estimatedPoses, ProcessingTime);

    end

% figure,
%     myPlotPlanes_v3(globalPlanes,1);
%     title(['global planes  in frame ' num2str(frameID)])
end

% write json file to disk
mySaveStruct2JSONFile(estimatedPoses,fileName,evalPath,sessionID);
return
% load initial pose
planeGroup=0;
planeDesc_m=loadInitialPose_v3(dataSetPath,sessionID,frameID,planeGroup);
% compute Tm2h
Th2m=loadTh2m(dataSetPath,sessionID);
Tm2h=inv(Th2m);
% project poses
planeDesc_h=projectPose(planeDesc_m,Tm2h);
Nb=size(planeDesc_h,2);
figure,
    myPlotPlanes_v3(globalPlanes,1);
    title(['global planes  in frame ' num2str(frameID)])
    hold on
    for k =1:Nb
        T=planeDesc_h(k).tform;
        ind=planeDesc_h(k).idBox;
        dibujarsistemaref(T,ind,120,2,10,'w')
        hold on
    end
%     axis square
    xlabel 'x'
    ylabel 'y'
    zlabel 'z'
    grid

end