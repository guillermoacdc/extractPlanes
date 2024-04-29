clc
close all
clear

sessionID=10;
fileName="visiblePlanesByFrame.json";
visibleBoxBySession=computeVisibleBoxesBySession(sessionID,fileName);
frameID=372;%9, 25, 83, 146,204,366,372
currentBoxes=computeCurrentBoxesByFrame(visibleBoxBySession, frameID, sessionID)
