function [height, width, depth, idBox] = refinateBoxLength(width, depth, height,...
    compensateHeight, sessionID, frameID)
%REFINATEBOXLENGTH Refinates the length in two steps: (1) adding a compensation
%height, (2) adjusting all lengths to the nearest length in consolidation
%zone. Also return the id of the nearest box in the consolidation zone

% first refination associated with compensation of height
height=height+compensateHeight;
% second refination using the nearest neighborhood 
[width, depth, height, idBox]=updateLengthWithNearestNeighborhood([width, depth, height], sessionID, frameID);

end

