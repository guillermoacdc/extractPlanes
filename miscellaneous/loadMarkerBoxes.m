function [mBoxes] = loadMarkerBoxes(markerIDPath,sessionID)
%loadMarkerBoxes loads the markers associated with each box (mBoxes) in 
% the sequence m1 m2 boxID
%   Detailed explanation goes here

append=computeAppendMocapFileName(sessionID);
fileName=['names' num2str(sessionID) '-00' num2str(append) '.csv'];

filePath=markerIDPath+fileName;

T=readtable(filePath);
mBoxes=table2array(T);
end

