clc
close all
clear

% rootPath="G:\Mi unidad\boxesDatabaseSample\";
sessionID=10;
dataSetPath=computeReadPaths(sessionID);
frameID=12;
% scene=3;
% frame=745;
% initialPoses = loadInitialPose(rootPath,scene,frame);
initialPoses = loadInitialPose(dataSetPath,sessionID,frameID);
size(initialPoses,1)