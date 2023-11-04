
% script to generate multiple boxes, each one with a predefinde pose 
% on the consolidation  zone
% _v5 projects to qh and plot estimated boxes
clc
close all
clear

sessionID=10;
dataSetPath=computeReadPaths(sessionID);
keyframes=loadKeyFrames(dataSetPath,sessionID);

frameHL2=25;
boxID=getPPS(dataSetPath,sessionID,frameHL2);
Nb=length(boxID);

% compute Tm2h
Th2m=loadTh2m(dataSetPath,sessionID);
Tm2h=inv(Th2m);

% sidesVector=[1:5];
sidesVector=[1 2 5; 1 3 4; 1 4 5; 1 4 5; 1 4 5; 1 2 5];
NpointsDiagTopSide=10;
gridStep=1;
% load descriptors of planes that compose boxID
for i=1:Nb
    planeDescriptor{i} = convertPK2PlaneObjects_v5(boxID(i),sessionID, ...
    sidesVector(i,:), frameHL2);
    % project poses
    planeDescriptor{i}=projectPose(planeDescriptor{i},Tm2h);
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
%     dibujarsistemaref(eye(4),'m',150,2,10,'w')
xlabel 'x'
ylabel 'y'
zlabel 'z'
grid on
title 'test on generate synthetic point cloud'


% load matGlobalBoxesFigures.mat
load matGlobalBoxesFigures.mat;
sessionID=10;
fc='b';
myPlotBoxContour(globalBoxes,sessionID,fc)
dibujarsistemaref(eye(4),'h',250,2,10,'w')