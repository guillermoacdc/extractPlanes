clc 
close all
clear

sessionID=10;
frameID=24;
planeType=1;
fileName='visiblePlanesByFrame.json';

visiblePlanesVector = loadVisiblePlanesByType(fileName,sessionID, frameID, planeType)
