clc
close all
clear

sessionID=5;
dataSetPath=computeMainPaths(sessionID);
planesGroup=1;
frame=1;
[initialPoses] = loadInitialPose_v2(dataSetPath,sessionID,frame,planesGroup)

[initialPoses2] = loadInitialPose(dataSetPath,sessionID,frame)