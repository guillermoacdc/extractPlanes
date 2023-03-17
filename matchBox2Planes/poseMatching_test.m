clc
close all
clear all

dataSetPath="G:\Mi unidad\boxesDatabaseSample\";
processedPlanesPath='G:\Mi unidad\semestre 9\lowOcclusionScenes_processed';
evalPath='G:\Mi unidad\semestre 9\lowOcclusionScenes_processed\evalFolder';
% basic IDs
sessionID=3;
frameID=6;
planeType=0;%{0 for xzPlanes, 1 for xyPlanes, 2 for zyPlanes} in qh_c coordinate system
%% parameters 2. Plane filtering (based on previous knowledge) and pose/length estimation. 
th_angle=15*pi/180;%radians
th_size=150;%number of points
th_lenght=10;% 10 cm - Update with tolerance_length; is in a high value (30) to pass most of the planes
th_occlusion=1.4;%
D_Tolerance=0.1;%mt
tresholdsV=[th_lenght, th_size, th_angle, th_occlusion, D_Tolerance];
%% parameters 3.  Pose matching
tao=50;
theta=0.5;
spatialSampling=10;
%% processing
% load extracted planes, filter planes, and estimated pose
estimatedPlanes=loadExtractedPlanes(dataSetPath,sessionID,frameID,processedPlanesPath, tresholdsV);
% pose matching
gtPoses=loadInitialPose(dataSetPath,sessionID,frameID);
poseMatching(sessionID, frameID, estimatedPlanes,planeType,...
    gtPoses,tao,theta,spatialSampling,dataSetPath, evalPath)


%% plotting
figure,
myPlotPlanes_v2(estimatedPlanes,estimatedPlanes.(['fr' num2str(frameID)]).acceptedPlanes)
title (['boxes detected in sessionID/frame ' num2str(sessionID) '/' num2str(frameID)])
localPlanes



