clc 
close all
clear


sessionID=10;
% planeType=0;
% fileName=['estimatedPoses_qh_planeType' num2str(planeType) '.json'];
% [~,evalPath,~]=computeMainPaths(sessionID);
fileName='estimatedPlanes.json';
app='_vdebug';
evalPath=computeReadWritePaths(app);
estimatedPoses = loadEstimationsFile(fileName,sessionID, evalPath);