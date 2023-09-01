clc
close all
clear

sessionID=27;
dataSetPath=computeMainPaths(sessionID);
planesGroup=0;
frame=675;
planeDescriptors = loadInitialPose_v3(dataSetPath,sessionID,frame,planesGroup);

% [initialPoses2] = loadInitialPose(dataSetPath,sessionID,frame)