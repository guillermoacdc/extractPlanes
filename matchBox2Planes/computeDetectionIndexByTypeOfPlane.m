clc
close all
clear


% define input parameters
rootPath="C:\lib\boxTrackinPCs\";
scene=6;
planeType=2;

% load pps
PPS=loadPPS(rootPath,scene);
N=size(PPS,1);
% compute tracking indexes and figures
for i=1:N
    boxID=PPS(i);
    measurePoseIndexesInPlanes(rootPath,scene,boxID,planeType);
    
end

