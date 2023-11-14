clc
close all
clear

visiblePlanesFileName="visiblePlanesByFrame.json";
sessionID=10;

visibleBoxBySession = computeVisibleBoxesBySession(sessionID,visiblePlanesFileName);