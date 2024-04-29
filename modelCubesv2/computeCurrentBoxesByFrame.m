function currentBoxes = computeCurrentBoxesByFrame(visibleBoxBySession,frameID, sessionID)
%COMPUTECURRENTBOXESBYFRAME Compute the id of boxes that satisfies two
%conditions
% (1) They are visible from mobile camera at instant frameID or at previous
% instants
% (2) they are in the consolidation zone at instant frameID
dataSetPath=computeReadPaths(sessionID);
keyFrames=loadKeyFrames(dataSetPath, sessionID);
Nkf=length(keyFrames);
maxI=find(keyFrames==frameID);

accumulateBox =[];
% condition 1
for i=1:maxI
    visibleBoxByFrame=visibleBoxBySession.(['frame' num2str(keyFrames(i))]);
    accumulateBox=[accumulateBox visibleBoxByFrame.boxID];
end
currentBoxes1=unique(accumulateBox);

% condition 2
extractedBoxes=computeExtractedBoxes(sessionID, frameID);
currentBoxes=setdiff(currentBoxes1,extractedBoxes);

end

