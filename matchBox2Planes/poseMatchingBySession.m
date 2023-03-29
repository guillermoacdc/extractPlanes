clc
close all
clear all

%dataSetPath="G:\Mi unidad\boxesDatabaseSample\";
dataSetPath="D:\6DViCuT_p1\";
% dataSetPath="/home/gacamacho/Documents/6DViCuT_v1/";

processedPlanesPath='G:\Mi unidad\semestre 9\lowOcclusionScenes_processed';
% processedPlanesPath='/home/gacamacho/Documents/PCs_extractedPlanes_v1/lowOcclusionScenes_processed';
% processedPlanesPath='/home/gacamacho/Documents/PCs_extractedPlanes_v1/MediumOcclusionScenes_processed';

evalPath='G:\Mi unidad\semestre 9\evalFolder';
% evalPath='/home/gacamacho/Documents/PCs_extractedPlanes_v1/evalFolder';
% basic IDs
sessionID=10;
planeType=0;%{0 for xzPlanes, 1 for xyPlanes, 2 for zyPlanes} in qh_c coordinate system
%% parameters 2. Plane filtering (based on previous knowledge) and pose/length estimation. 
th_angle=15*pi/180;%radians
th_size=150;%number of points
th_lenght=10;% 10 cm - Update with tolerance_length; is in a high value (30) to pass most of the planes
th_occlusion=1.4;%
D_Tolerance=0.1;%mt
tresholdsV=[th_lenght, th_size, th_angle, th_occlusion, D_Tolerance];
%% parameters 3.  Pose matching
tao_v=[10:10:50];
theta_v=[0.1:0.1:0.5];
spatialSampling=10;
%% processing
% computing keyframes for the session
keyframes=loadKeyFrames(dataSetPath,sessionID);
Nframes=length(keyframes);
Ntao=length(tao_v);
Ntheta=length(theta_v);
% performing the computation for each frame

for i=1:Nframes
    frameID=keyframes(i);
    gtPoses=loadInitialPose(dataSetPath,sessionID,frameID);
    estimatedPlanes=loadExtractedPlanes(dataSetPath,sessionID,frameID,...
        processedPlanesPath, tresholdsV);
    for j=1:Ntao
        tao=tao_v(j);
        for k=1:Ntheta
            theta=theta_v(k);
            logtxt=['Matching of frame ' num2str(frameID) ' with tao/theta= '...
                num2str(tao) '/' num2str(theta)];
            writeProcessingState(logtxt,evalPath,sessionID);
            disp(logtxt);
            poseMatching_v2(sessionID, frameID, estimatedPlanes,planeType,...
            gtPoses,tao,theta,spatialSampling,dataSetPath, evalPath)
        end
    end
end

return

%% plotting
% create folder
% save the current path
currentcd=pwd;
% go to evalpath 
cd (evalPath);
% create folder
folderName=['scene' num2str(sessionID)];
folderExists=isfolder(folderName);
if ~folderExists
    mkdir (folderName);
end
figure,
fileName=['frame' num2str(frameID) '.jpg'];
myPlotPlanes_v2(estimatedPlanes,estimatedPlanes.(['fr' num2str(frameID)]).acceptedPlanes)
title (['boxes detected in sessionID/frame ' num2str(sessionID) '/' num2str(frameID)])
saveas(gcf,[evalPath '\' folderName '\' fileName])



