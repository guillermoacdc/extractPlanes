clc
close all
clear

sessionID=10;
frameID=2;
planesGroup=0;

planeDescriptors_rel = loadInitialPose_relative(sessionID, frameID,planesGroup);