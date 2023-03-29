clc
close all
clear


dataSetPath="D:\6DViCuT_p1\";
% dataSetPath="/home/gacamacho/Documents/6DViCuT_v1/";

processedPlanesPath='G:\Mi unidad\semestre 9\lowOcclusionScenes_processed';
% processedPlanesPath='/home/gacamacho/Documents/PCs_extractedPlanes_v1/lowOcclusionScenes_processed';
% processedPlanesPath='/home/gacamacho/Documents/PCs_extractedPlanes_v1/MediumOcclusionScenes_processed';

evalPath='G:\Mi unidad\semestre 9\evalFolder';
% evalPath='/home/gacamacho/Documents/PCs_extractedPlanes_v1/evalFolder';

% basic IDs
sessionID=10;
frameID=14;
tao=50;
theta=0.5;
spatialSampling=10;
planeType=0;%{0 for xzPlanes, 1 for xyPlanes, 2 for zyPlanes} in qh_c coordinate system
%% parameters 2. Plane filtering (based on previous knowledge) and pose/length estimation. 
th_angle=15*pi/180;%radians
th_size=150;%number of points
th_lenght=10;% 10 cm - Update with tolerance_length; is in a high value (30) to pass most of the planes
th_occlusion=1.4;%
D_Tolerance=0.1;%mt
tresholdsV=[th_lenght, th_size, th_angle, th_occlusion, D_Tolerance];

T=plotEstimatedPlanesByFrame(dataSetPath,sessionID,frameID,...
    processedPlanesPath,tresholdsV, planeType,tao,theta,spatialSampling, evalPath)
pps=getPPS(dataSetPath,sessionID)