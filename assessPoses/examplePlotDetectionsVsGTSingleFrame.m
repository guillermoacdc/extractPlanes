clc
close all
clear

sessionID=10;
[dataSetPath,evalPath,PCpath] = computeMainPaths(sessionID);
frameID=14; 
tao=50;
theta=0.5;
NpointsDiagTopSide=50;%used in the creation of synthetic point clouds
planeType=0;
% evalPath='G:\Mi unidad\semestre 9\evalFolder';
% dataSetPath='D:\6DViCuT_p1'; PCpath='G:\Mi unidad\semestre
% 9\lowOcclusionScenes_processed';
eADD_m=plot_eADDByFrame(sessionID,frameID,tao,theta,evalPath,dataSetPath, PCpath,...
    NpointsDiagTopSide, planeType)