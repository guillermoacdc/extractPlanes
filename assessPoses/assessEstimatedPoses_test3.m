% modification of functions to avoid passing a field called frame: v2
% first version of an incremental approach. 
clc
close all
clear

sessionID=5;
[dataSetPath,evalPath,PCpath] = computeMainPaths(sessionID);
fileName='estimatedPoses_ia1.json';

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
%% parameters 4. Merging planes between frames
% parameters of merging planes - used in the function computeTypeOfTwin
tao_merg=50/1000;%in meters----50mm
theta_merg=0.5;%in percentage

%% processing
% computing keyframes for the session
keyframes=loadKeyFrames(dataSetPath,sessionID);

Nframes=length(keyframes);
Ntao=length(tao_v);

% performing the computation for each frame
estimatedPoses.tao=tao_v;
% for i=1:Nframes
for i=1:5
    frameID=keyframes(i);
    logtxt=['Assessing detections in frame ' num2str(frameID)];
    disp(logtxt);
    %     writeProcessingState(logtxt,evalPath,sessionID);

    gtPoses=loadInitialPose(dataSetPath,sessionID,frameID);
    estimatedPlanesfr=loadExtractedPlanes(dataSetPath,sessionID,frameID,...
        PCpath, tresholdsV);%returns a struct with a property frx
    % extract target identifiers based on type of plane
    estimatedPlanesID=extractTargetIDs(estimatedPlanesfr,frameID,planeType);

    if isempty(estimatedPlanesID)
        estimatedPoses.(['frame' num2str(frameID)])=[];%empty frames are frames where detections were null
        continue
    else
        

        estimatedPlanes=loadPlanesFromIDs(estimatedPlanesfr,estimatedPlanesID);%vector
    
    %     project estimated poses to qm. The rest of properties is kept
        estimatedPlanes_m=myProjectionPlaneObject_v2(estimatedPlanes,...
            sessionID,dataSetPath);



        estimatedPoses.(['frame' num2str(frameID)]).IDObjects=estimatedPlanesID;
        [poses, L1e, L2e, dc, Ninliers]=convertToArrays_v2(estimatedPlanes_m,estimatedPlanesID);
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
            estimatedPoses.(['frame' num2str(frameID)]).eADD.(['tao' num2str(tao)])=compute_eADD_v2(estimatedPlanes,...
             gtPoses,  tao, dataSetPath);
        end
%     write descriptors of length, ninliers, dc, ... to the struct

    end

%     
end

return
% write json file to disk
mySaveStruct2JSONFile(estimatedPoses,fileName,evalPath,sessionID);


return
% removing warnings
w = warning('query','last');
id=w.identifier;
warning('off',id)
