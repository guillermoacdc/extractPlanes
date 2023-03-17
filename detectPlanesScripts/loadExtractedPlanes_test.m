clc
close all
clear all

rootPath="G:\Mi unidad\boxesDatabaseSample\";
processedPlanesPath='G:\Mi unidad\semestre 9\lowOcclusionScenes_processed';
scene=3;
frame=5;
th_angle=15*pi/180;%radians
th_size=150;%number of points
th_lenght=10;% 10 cm - Update with tolerance_length; is in a high value (30) to pass most of the planes
th_occlusion=1.4;%
D_Tolerance=0.1;%mt
tresholdsV=[th_lenght, th_size, th_angle, th_occlusion, D_Tolerance];

localPlanes=loadExtractedPlanes(rootPath,scene,frame,processedPlanesPath, tresholdsV);
figure,
myPlotPlanes_v2(localPlanes,localPlanes.(['fr' num2str(frame)]).acceptedPlanes)
title (['boxes detected in scene/frame ' num2str(scene) '/' num2str(frame)])



