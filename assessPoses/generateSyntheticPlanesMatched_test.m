clc
close all
clear


sessionID=10;
boxID=30;
frameID=14;
planeID=4;
tao=50;
planeType=0;
NpointsDiagTopSide=50;
numberOfSides=1;
fileName='estimatedPoses.json';
[dataSetPath,evalPath] = computeMainPaths(sessionID);

[pc_e, pc_gt, Te, T_gt, eADD]=generateSyntheticPlanesMatched(sessionID,boxID, frameID,...
    planeID, planeType, NpointsDiagTopSide, numberOfSides, tao, fileName, dataSetPath, evalPath);

figure,
pcshow(pc_gt)
hold
pcshow(pc_e, "MarkerSize", 10)
dibujarsistemaref(Te,'e',120,2,10,'w')
dibujarsistemaref(T_gt,boxID,120,2,10,'w')
title (['Synthetic pcs. Estimated in white. GT in green. e_{ADD}= ' num2str(eADD) ' for tao= ' num2str(tao)])
grid



