% This scripts loads and plot an input frame 

clc
close all
clear all

% scene=3;
% frame=24;

scene=5;%
frame=5;

% scene=6;
% frame=66;

% scene=51;
% frame=6;

% scene=51;
% frame=29;
rootPath="C:\lib\boxTrackinPCs\";
pathPoints=[rootPath + ['\scene' num2str(scene) '\inputFrames\frame' num2str(frame) '.ply'] ];

pc = pcread(pathPoints);%in [mt]; indices begin at 0
% convert to mm
    xyz=pc.Location*1000;
    pc_mm=pointCloud(xyz);
%% filter the pc
% filter parameters
maxDistance=20;%mm
refVector=[0 1 0];
cameraPoses=importdata(rootPath+['scene' num2str(scene)]+'\Depth Long Throw_rig2world.txt');
cameraPosition=cameraPoses(frame,[5 9 13])*1000;
opRange=[0.5 3]*1000;%[min max] in mm

pc_filtered=filterRawPC(pc_mm,maxDistance,refVector, cameraPosition, opRange);



% return
figure,
pcshow(pc_filtered)
xlabel 'x'
ylabel 'y'
zlabel 'z'
grid on
title (['pc from scene/frame ' num2str(scene) '/' num2str(frame)])

return
figure,
pcshow(pc_woutGround)
xlabel 'x'
ylabel 'y'
zlabel 'z'
grid on
title (['pc from scene/frame ' num2str(scene) '/' num2str(frame)])
