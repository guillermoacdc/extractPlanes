clc 
close all
clear


sessionID=10;
% planeType=0;
% fileName=['estimatedPoses_qh_planeType' num2str(planeType) '.json'];
% [~,evalPath,~]=computeMainPaths(sessionID);
% fileName='estimatedPlanes.json';
fileName='estimatedBoxes_pk1.json';
% app='_vdebug';
app='_v16';
evalPath=computeReadWritePaths(app);
estimatedPoses = loadEstimationsFile(fileName,sessionID, evalPath);