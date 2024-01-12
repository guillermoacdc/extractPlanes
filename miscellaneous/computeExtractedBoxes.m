function extractedBoxesID = computeExtractedBoxes(sessionID, frameID)
%COMPUTEEXTRACTEDBOXES Computes boxes that have been extracted from packing
%zones
%   Detailed explanation goes here
dataSetPath=computeReadPaths(sessionID);
initBoxes=getPPS(dataSetPath, sessionID, 1);
currentBoxes=getPPS(dataSetPath, sessionID, frameID);
extractedBoxesID=setdiff(initBoxes,currentBoxes);
end

