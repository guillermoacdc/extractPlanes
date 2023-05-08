clc
close all
clear all


sessionID=27;
dataSetPath=computeMainPaths(sessionID);
frameID=800;
pps = getPPS(dataSetPath,sessionID,frameID)