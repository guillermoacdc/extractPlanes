clc
close all
clear

sessionID=10;
[dataSetPath,evalPath,PCpath] = computeMainPaths(sessionID);
fileName='estimatedPoses.json';

planeType=0;%{0 for xzPlanes, 1 for xyPlanes, 2 for zyPlanes} in qh_c coordinate system
%% parameters 2. Plane filtering (based on previous knowledge) and pose/length estimation. 
th_angle=15*pi/180;%radians
th_size=150;%number of points
th_lenght=10;% 10 cm - Update with tolerance_length; is in a high value (30) to pass most of the planes
th_occlusion=1.4;%
D_Tolerance=0.1;%mt
tresholdsV=[th_lenght, th_size, th_angle, th_occlusion, D_Tolerance];
%% parameters 3.  Assesment Pose with e_ADD
tao_v=10:10:50;

%% processing
% computing keyframes for the session
keyframes=loadKeyFrames(dataSetPath,sessionID);

Nframes=length(keyframes);
Ntao=length(tao_v);

% performing the computation for each frame
estimatedPoses.tao=tao_v;
% for i=1:Nframes
for i=1:10
    frameID=keyframes(i);
    gtPoses=loadInitialPose(dataSetPath,sessionID,frameID);
    estimatedPlanes=loadExtractedPlanes(dataSetPath,sessionID,frameID,...
        PCpath, tresholdsV);
%     project estimated planes to qm
    estimatedPlanes_m=myProjectionPlaneObject(estimatedPlanes,frameID,...
        sessionID,dataSetPath);
    logtxt=['Assessing detections in frame ' num2str(frameID)];
    disp(logtxt);
    %     writeProcessingState(logtxt,evalPath,sessionID);
% restrict by type of plane
    [xzPlanes, xyPlanes, zyPlanes] =extractTypes(estimatedPlanes_m,...
        estimatedPlanes.(['fr' num2str(frameID)]).acceptedPlanes); 
    switch planeType
        case 0
            estimatedPlanesID = xzPlanes;
        case 1
            estimatedPlanesID = xyPlanes;
        case 2
            estimatedPlanesID = zyPlanes;
    end

    if isempty(estimatedPlanesID)
        estimatedPoses.(['frame' num2str(frameID)])=[];%empty frames are frames where detections were null
        continue
    else
        estimatedPoses.(['frame' num2str(frameID)]).IDObjects=estimatedPlanesID(:,2);
        [poses, L1e, L2e, dc, Ninliers]=convertToArrays(estimatedPlanes_m,estimatedPlanesID);
        estimatedPoses.(['frame' num2str(frameID)]).poses=poses;
        estimatedPoses.(['frame' num2str(frameID)]).L1=L1e;
        estimatedPoses.(['frame' num2str(frameID)]).L2=L2e;
        estimatedPoses.(['frame' num2str(frameID)]).Ninliers=Ninliers;
        estimatedPoses.(['frame' num2str(frameID)]).dc=dc;
        for j=1:Ntao
            tao=tao_v(j);
            logtxt=['Processing with tao= ' num2str(tao)];
            disp(logtxt);
    %         writeProcessingState(logtxt,evalPath,sessionID);
    %         write eADD to the struct
            estimatedPoses.(['frame' num2str(frameID)]).eADD.(['tao' num2str(tao)])=compute_eADD(estimatedPlanes,...
            estimatedPlanesID, gtPoses, frameID, tao, dataSetPath);
        end
%     write descriptors of length, ninliers, dc, ... to the struct

    end

%     
end
% write json file to disk
mySaveStruct2JSONFile(estimatedPoses,fileName,evalPath,sessionID);


return
% removing warnings
w = warning('query','last');
id=w.identifier;
warning('off',id)
