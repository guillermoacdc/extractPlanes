function box = refinateBoxSize(box,sessionID, frameID)
%REFINATEBOXSIZE Refinates the SIZE adjusting all lengths to the nearest 
% length in consolidation zone. 
% Also return the id of the nearest box in the consolidation zone

% refination using the nearest neighborhood 
[width, depth, height, idBox]=updateLengthWithNearestNeighborhood([box.width, box.depth, box.height], sessionID, frameID);
box.width=width;
box.depth=depth;
box.height=height;
box.id=idBox;
end

