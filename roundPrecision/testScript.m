clc
close all
clear all

sceneNumber=6;
% pathToDoublePointClouds=['~/Documents/boxesDatabaseSample/corrida'  num2str(sceneNumber)  '/Depth Long Throw/'];
pathToDoublePointClouds=['G:\Mi unidad\boxesDatabaseSample\corrida'  num2str(sceneNumber)  '\Depth Long Throw\'];

% pathToFramesID=['~/Documents/boxesDatabaseSample/corrida'  num2str(sceneNumber)  '/pinhole_projection/boxByFrame.txt'];
pathToFramesID=['G:\Mi unidad\boxesDatabaseSample\corrida'    num2str(sceneNumber)  '\pinhole_projection\boxByFrame.txt'];

% pathToSinglePointClouds=['~/Documents/singlePointClouds/'];
pathToSinglePointClouds=['G:\Mi unidad\boxesDatabaseSample\corrida'    num2str(sceneNumber) ];


double2singlePCs_vtext(sceneNumber, pathToDoublePointClouds, ...
    pathToFramesID, pathToSinglePointClouds)