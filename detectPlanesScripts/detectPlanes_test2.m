clc
close all
clear all


% rootPath="C:\lib\boxTrackinPCs\";
rootPath="G:\Mi unidad\boxesDatabaseSample\";
processedPlanesPath='G:\Mi unidad\semestre 9\lowOcclusionScenes_processed';
scene=3;
frame=63;
localPlanes=loadExtractedPlanes(rootPath,scene,frame,processedPlanesPath);

figure,
myPlotPlanes_v2(localPlanes,localPlanes.(['fr' num2str(frame)]).acceptedPlanes)
title (['boxes detected in scene/frame ' num2str(scene) '/' num2str(frame)])



