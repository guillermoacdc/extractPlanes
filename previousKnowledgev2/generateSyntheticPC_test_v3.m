
% script to generate a single box in a predefinde pose of the consolidation
% zone
clc
close all
clear

sessionID=10;
dataSetPath=computeReadPaths(sessionID);
keyframes=loadKeyFrames(dataSetPath,sessionID);

frameHL2=25;
% boxID=getPPS(dataSetPath,sessionID,frameHL2);
boxID=30;
sidesVector=[1:5];
NpointsDiagTopSide=50;
gridStep=1;
% load descriptors of planes that compose boxID
planeDescriptor = convertPK2PlaneObjects_v5(boxID,sessionID, ...
    sidesVector, frameHL2);

% create synthetic PC
pc=createSyntheticPC_v2(planeDescriptor,NpointsDiagTopSide,boxID, gridStep, dataSetPath);

figure,
    pcshow(pc)
    hold 
    dibujarsistemaref(planeDescriptor(1).tform,boxID,150,2,10,'w')
    hold on
    myPlotPlanes_Anotation(planeDescriptor,0,'m')
    hold on
    dibujarsistemaref(eye(4),'m',150,2,10,'w')
xlabel 'x'
ylabel 'y'
zlabel 'z'
grid on
title 'test on generate synthetic point cloud'
