% This scripts loads and plot an input frame 

clc
close all
clear all

% scene=3;
% frames=[24 25];

scene=5;%
frames=[4 5];

% scene=6;
% frame=66;

% scene=51;
% frames=[6 7];

% scene=51;
% frame=29;
rootPath="G:\Mi unidad\boxesDatabaseSample";
% filter parameters
maxDistance=30;%mm. To delete ground plane
refVector=[0 1 0];%. To delete ground plane
opRange=[0.5 3]*1000;%[min max] in mm. To filter points by distance to camera
gridStep=10;%grid step using for fusion

pc=fusionFrames(frames,scene,rootPath,maxDistance,refVector,opRange,gridStep);

% return
figure,
pcshow(pc)
xlabel 'x'
ylabel 'y'
zlabel 'z'
grid on
title (['pc from scene/frames ' num2str(scene) '/' num2str(frames)])

return
figure,
pcshow(pc_woutGround)
xlabel 'x'
ylabel 'y'
zlabel 'z'
grid on
title (['pc from scene/frame ' num2str(scene) '/' num2str(frames)])
