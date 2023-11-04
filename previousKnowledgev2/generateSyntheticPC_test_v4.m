
% script to generate multiple boxes, each one witha a predefinde pose 
% on the consolidation  zone
clc
close all
clear

sessionID=10;
dataSetPath=computeReadPaths(sessionID);
keyframes=loadKeyFrames(dataSetPath,sessionID);

frameHL2=25;
boxID=getPPS(dataSetPath,sessionID,frameHL2);
Nb=length(boxID);
% sidesVector=[1:5];
sidesVector=[1 2 5; 1 3 4; 1 4 5; 1 4 5; 1 4 5; 1 2 5];
NpointsDiagTopSide=50;
gridStep=1;
% load descriptors of planes that compose boxID
for i=1:Nb
    planeDescriptor{i} = convertPK2PlaneObjects_v5(boxID(i),sessionID, ...
    sidesVector(i,:), frameHL2);
end
% create synthetic PC
for i=1:Nb
    pc{i}=createSyntheticPC_v2(planeDescriptor{i},NpointsDiagTopSide,boxID(i), gridStep, dataSetPath);
end

figure,
for i=1:Nb
    pcshow(pc{i})
    hold on
    dibujarsistemaref(planeDescriptor{i}(1).tform,boxID(i),150,2,10,'w');
    hold on
    myPlotPlanes_Anotation(planeDescriptor{i},0,'m')
   hold on
end    
    dibujarsistemaref(eye(4),'m',150,2,10,'w')
xlabel 'x'
ylabel 'y'
zlabel 'z'
grid on
title 'test on generate synthetic point cloud'
