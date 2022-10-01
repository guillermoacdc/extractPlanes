% This scripts loads and plot an input frame 

clc
close all
clear all

% scene=3;
% frame=24;

scene=5;%
frame=4;

% scene=6;
% frame=66;

% scene=51;
% frame=6;

% scene=51;
% frame=29;
rootPath="C:\lib\boxTrackinPCs\";



[pc_mm, T]=loadSLAMoutput(scene,frame,rootPath); 

%% filter the pc
% filter parameters
maxDistance=20;%mm
refVector=[0 1 0];
opRange=[0.5 3]*1000;%[min max] in mm

cameraPosition=T(1:3,4);
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
