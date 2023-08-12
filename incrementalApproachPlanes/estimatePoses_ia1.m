
function estimatePoses_ia1(sessionID, fileName, planeFilteringParameters, ...
            asessmentPoseParameters, mergingPlaneParameters, tempFilteringParameters, ...
            planeType)
% ESTIMATEPOSES_IA1()  First version of an incremental approach. In the 
% merge stage performs a % selection of planes. This selection is based on 
% criteria of distance % between camera and object, area of the candidates 
% and intersection over % union metrics. 
disp(['----------computing performance in session ' num2str(sessionID) ' under algorithm 1'])
%% unzip parameters
% 2. Parameters used in the stage Assesment Pose 
NpointsDiagPpal=asessmentPoseParameters(1);
tao_v=asessmentPoseParameters(2);%mm

% 3. Parameteres used in the stage Merging planes between frames
% - used in the function computeTypeOfTwin
tao_merg=mergingPlaneParameters(1);% mm
theta_merg=mergingPlaneParameters(2);%in percentage
th_IoU=mergingPlaneParameters(3);% percent
th_coplanarDistance=mergingPlaneParameters(4);%mm

% 4. Parameters used in temporal filtering stage
radii=tempFilteringParameters(1);%mm - initial value. The raddi changes every time a box is extracted from consolidation zone
windowSize=tempFilteringParameters(2);%frames
th_detections=tempFilteringParameters(3);%percent - not used in version 1
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
    syntheticPlaneType=0;
    estimatedPlaneType=0;
else
    % For perpendicular planes use
    syntheticPlaneType=3;
    estimatedPlaneType=3;
end

% 6. paths to read and write data
[dataSetPath,evalPath,PCpath] = computeMainPaths(sessionID);

%% processing
% computing keyframes for the session
keyframes=loadKeyFrames(dataSetPath,sessionID);
Nframes=length(keyframes);
% performing the computation for each frame
estimatedPoses.tao=tao_v;
globalPlanesPrevious=[];
globalPlanes=[];
localPlanes=[];
for i=1:Nframes
    tic;% init timer
    frameID=keyframes(i);
    radii=computeRaddi(dataSetPath,sessionID,frameID,estimatedPlaneType);%use of pps
    logtxt=['Assessing detections in frame ' num2str(frameID) ' with radii ' num2str(radii) ' mm. i=' num2str(i) '/' num2str(length(keyframes))];
    disp(logtxt);
%     disp(i, frameID, size(localPlanes), size(globalPlanes), size(particlesVector))
    if  i==17
        disp("stop mark")
    end
%%     writeProcessingState(logtxt,evalPath,sessionID);

    gtPlanes=loadInitialPose_v3(dataSetPath,sessionID,frameID, syntheticPlaneType);
    [estimatedPlanesfr ]=loadExtractedPlanes(dataSetPath,sessionID,frameID,...
        PCpath, planeFilteringParameters);%returns a struct with a property frx - h world
%     compute number of non accepted (or rejected) planes by local frame
    Nnap=size(estimatedPlanesfr.(['fr' num2str(frameID)]).values,2)-size(estimatedPlanesfr.(['fr' num2str(frameID)]).acceptedPlanes,1);
    estimatedPoses.(['frame' num2str(frameID)]).Nnap=Nnap;
%     disp(['Nnap in frame ' num2str(frameID) ': ' num2str(Nnap)])

%% extract target identifiers based on type of plane
    estimatedPlanesID=extractTargetIDs(estimatedPlanesfr,frameID,estimatedPlaneType);
%% forget old planes
        if mod(i,windowSize)==0 %& i>=2*windowSize
            if (i-windowSize)>=1
                windowInit=keyframes(i-windowSize);
            else
                windowInit=keyframes(1);
            end
            globalPlanes=updatePresence_v2(globalPlanes,particlesVector,windowInit, th_detections);
        end
%% fill estimatedPoses output
    if isempty(estimatedPlanesID)
        estimatedPoses.(['frame' num2str(frameID)])=[];%empty frames are frames where detections were null
        toc; %close the timer
        continue
    else
%% convert struct to vector localPlanes
        localPlanes=loadPlanesFromIDs(estimatedPlanesfr,estimatedPlanesID);%vector in h world
% compute presence of a particle using localPlanes
        [particlesVector, localPlanes]= computeParticlesVector_v2(localPlanes,...
                    particlesVector, radii, frameID);
        
%% update globalPlanesPrevious vector        
        if isempty(globalPlanesPrevious)
            globalPlanesPrevious=clonePlaneObject(localPlanes);%h-world
        else
            globalPlanesPrevious=clonePlaneObject(globalPlanes);
        end
%% perform the merge        
        globalPlanes=mergeIntoGlobalPlanes(localPlanes,globalPlanesPrevious,tao_merg,theta_merg);%h-world
        globalPlanes=mergePlanesOfASingleFrame_a1(globalPlanes, th_IoU, th_coplanarDistance);

% associate particles with global planes
globalPlanes = associateParticlesWithGlobalPlanes(globalPlanes,particlesVector, radii);

ProcessingTime=toc;%stop the timer

% project estimated poses to qm and compute estimatedPoses struct. The rest of properties is kept
        globalPlanes_t=clonePlaneObject(globalPlanes);
        estimatedGlobalPlanesID=extractIDsFromVector(globalPlanes_t);
        estimatedPoses=computeEstimatedPosesStruct_v2(globalPlanes_t,gtPlanes,...
            sessionID,frameID,estimatedGlobalPlanesID,tao_v,dataSetPath,...
            NpointsDiagPpal,estimatedPoses, ProcessingTime);

    end

%     
end
% write json file to disk

mySaveStruct2JSONFile(estimatedPoses,fileName,evalPath,sessionID);
% figure,
%     myPlotPlanes_v3(globalPlanes,1);
%     title(['global planes  in frame ' num2str(frameID)])
return 

% figure,
%     myPlotPlanes_v3(localPlanes,0);
%     title(['local planes in frame ' num2str(frameID)])
% 

% 
% figure,
%     myPlotPlanes_v3(globalPlanesPrevious,0);
%     title(['previous global planes in frame ' num2str(frameID)])




