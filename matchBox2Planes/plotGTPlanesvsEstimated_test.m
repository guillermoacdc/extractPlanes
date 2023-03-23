clc
close all
clear


sessionID=10;
frameID=14; %14
tao=50;
theta=0.1;
spatialSampling=10;
evalPath='G:\Mi unidad\pruebasUbuntu\evalFolder\';
dataSetPath="G:\Mi unidad\boxesDatabaseSample\";

plotGTPlanesvsEstimated(sessionID, frameID, tao, theta, spatialSampling, evalPath, dataSetPath)