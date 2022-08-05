clc 
close all
clear 
% script to plot a single frame from an specific scene
scene=5;
frame=2;

% paths to data
rootPath=["C:\lib\boxTrackinPCs\"];
PCFileName=rootPath+"scene"+num2str(scene)+"\inputFrames\frame"+num2str(frame)+".ply";
% rootPath=["C:\lib\scene5\"];
% PCFileName=rootPath+"inputScenes"+"\frame"+num2str(frame)+".ply";


% load data
pc_raw=pcread(PCFileName);
% plot data
figure,
pcshow(pc_raw);
grid on
view(2)
camup([0 1 0])
xlabel 'x (m)'
ylabel 'y (m)'
zlabel 'z (m)'
title (['PC from scene' num2str(scene) ', frame' num2str(frame)])