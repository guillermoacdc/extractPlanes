clc 
close all
clear

sessionID=10;
frameID=12;
planeType=1;
fileName='visiblePlanesByFrame.json';

visiblePlanesVector = loadVisiblePlanesByType(fileName,sessionID, frameID, planeType)
