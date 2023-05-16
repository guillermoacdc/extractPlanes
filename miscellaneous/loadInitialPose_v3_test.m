clc
close all
clear

sessionID=5;
dataSetPath=computeMainPaths(sessionID);
planesGroup=2;
frame=1;
planeDescriptors = loadInitialPose_v3(dataSetPath,sessionID,frame,planesGroup);

% [initialPoses2] = loadInitialPose(dataSetPath,sessionID,frame)