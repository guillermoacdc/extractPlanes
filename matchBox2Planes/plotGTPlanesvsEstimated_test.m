clc
close all
clear


sessionID=10;
frameID=20; %14
tao=50;
theta=0.1;
spatialSampling=10;
evalPath='G:\Mi unidad\pruebasUbuntu\evalFolder\';
% dataSetPath="G:\Mi unidad\boxesDatabaseSample\";
dataSetPath="D:\6DViCuT_p1\";

plotGTPlanesvsEstimated(sessionID, frameID, tao, theta, spatialSampling, evalPath, dataSetPath)