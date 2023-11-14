clc
close all
clear

sessionID=10;
frameID=6;
dataSetPath=computeReadPaths(sessionID);
pps=getPPS(dataSetPath,sessionID,frameID);
boxLengths= loadLengths_v2(dataSetPath,pps);