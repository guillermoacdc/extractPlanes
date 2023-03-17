clc
close all
clear

datasetPath="G:\Mi unidad\boxesDatabaseSample\";
detectionsPath='G:\Mi unidad\semestre 9\lowOcclusionScenes_processed';
evalPath='G:\Mi unidad\semestre 9\lowOcclusionScenes_processed\evalFolder';
spatialSampling=10;
th_vector=[5, 80, 0.4 ];%er(deg), tao(mm), theta(%) 
scene=32;
planeType=0;%0:xz; 1:xy; 2:zy
computePoseErrorByScene(scene, datasetPath, evalPath, detectionsPath,...
    spatialSampling, planeType, th_vector);

