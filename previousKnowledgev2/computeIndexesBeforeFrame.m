function indexesBeforeFrame = computeIndexesBeforeFrame(lastFrameArray,frame)
%COMPUTEINDEXESBEFOREFRAME Computes the numbe of boxes in the consolidation
%zone in function of the HL2 frame value
%   Detailed explanation goes here
indexes=find(lastFrameArray>=frame);
indexesBeforeFrame=size(lastFrameArray,1)-size(indexes,1)+1;
end

