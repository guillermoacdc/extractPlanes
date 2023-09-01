clc
close all
clear

sessionID=3;
dataSetPath=computeMainPaths(sessionID);
planeType=0;
frameHL2=14;
% boxID=getPPS(dataSetPath,sessionID,frameHL2);
boxID=19;
sidesVector=[2 3 5];
NpointsDiagTopSide=100;
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
    dibujarsistemaref(eye(4),'m',150,2,10,'w')
xlabel 'x'
ylabel 'y'
zlabel 'z'
grid on
title 'test on generate synthetic point cloud'
