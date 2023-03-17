clc
close all
clear

% getPPS(rootPath,1)
scene=6;
boxID=22;%22
planeType=0;%options: 0 (xy), 1 (xz), 2 (yz)
% rootPath="C:\lib\boxTrackinPCsv2\";
rootPath="G:\Mi unidad\boxesDatabaseSample\";
processedScenesPath='G:\Mi unidad\semestre 9\MediumOcclusionScenes_processed';
% processedScenesPath='G:\Mi unidad\semestre 9\lowOcclusionScenes_processed';

measurePoseIndexesInPlanes(rootPath,processedScenesPath,scene,boxID,planeType)

