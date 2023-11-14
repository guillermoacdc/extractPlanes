function visibleBoxBySession = computeVisibleBoxesBySession(sessionID,fileName)
%COMPUTEVISIBLEBOXESBYSESSION Computes the id of visible boxes by session

dataSetPath=computeReadPaths(sessionID);
visiblePlanesBySession = loadVisiblePlanesBySession(fileName,sessionID);
keyFrames=loadKeyFrames(dataSetPath,sessionID);
Nkf=length(keyFrames);

for i=1:Nkf
    frameID=keyFrames(i);
    visiblePlanesByFrame=visiblePlanesBySession.(['frame' num2str(frameID)]);
    visibleBoxBySession.(['frame' num2str(frameID)]).boxID=computeVisibleBoxesByFrame(visiblePlanesByFrame);
end

end

