clc
close all
clear

rootPath="G:\Mi unidad\boxesDatabaseSample\";
scene=3;
frame=745;
initialPoses = loadInitialPose(rootPath,scene,frame);
size(initialPoses,1)