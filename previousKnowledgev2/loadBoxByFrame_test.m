clc
close all
clear

% datasetPath="G:\Mi unidad\boxesDatabaseSample\";
scene=10;
datasetPath=computeReadPaths(scene);
boxByFrameA = loadBoxByFrame(datasetPath,scene)