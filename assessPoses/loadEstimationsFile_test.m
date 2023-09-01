clc 
close all
clear


sessionID=12;
planeType=0;
fileName=['estimatedPoses_qh_planeType' num2str(planeType) '.json'];
[~,evalPath,~]=computeMainPaths(sessionID);
estimatedPoses = loadEstimationsFile(fileName,sessionID, evalPath)