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
fileName='estimatedPoses_ia1.json';
% fileName='estimatedPoses.json';

eADD_m=plot_eADDByFrame(sessionID,frameID,tao,theta,evalPath,dataSetPath, PCpath,...
    NpointsDiagTopSide, planeType, fileName)