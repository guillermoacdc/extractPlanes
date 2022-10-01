clc
close all
clear


markerIDs=[0 3 4 5 6];
rootPath="C:\lib\boxTrackinPCs\";
scene=51;
nmbFrames=loadNumberSamplesMocap(rootPath,scene);
sample=[1:nmbFrames];
position = loadHL2MarkPosAtSample(scene,rootPath,sample);

[pos_matrix] = myStruct2Matrix(position,markerIDs);