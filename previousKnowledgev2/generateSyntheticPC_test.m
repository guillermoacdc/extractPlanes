clc
close all
clear

dataSetPath='D:\6DViCuT_p1';
sessionID=10;
planeType=0;
frameHL2=14;
% boxID=getPPS(dataSetPath,sessionID,frameHL2);
boxID=30;
numberOfSides=3;
NpointsDiagTopSide=50;

pc = generateSyntheticPC(boxID,sessionID, ...
    numberOfSides, frameHL2, NpointsDiagTopSide, planeType, dataSetPath);

figure,
pcshow(pc)
hold on
xlabel 'x'
ylabel 'y'
zlabel 'z'
grid on
title 'test on generate synthetic point cloud'