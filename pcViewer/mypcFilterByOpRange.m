function [inliersIndices, outliersIndices]=mypcFilterByOpRange(pc,opRange,cameraPosition)
%MYPCFILTERBYOPRANGE Summary of this function goes here
%   Detailed explanation goes here

outliersIndices=[];
inliersIndices=[];
for i=1:pc.Count
    pointDistance=norm(cameraPosition-pc.Location(i,:));%update with the distance to camera. This one 
%     is different of the distance to h world
    if pointDistance>opRange(2)
        outliersIndices=[outliersIndices; i];
    else
        inliersIndices=[inliersIndices; i];
    end

    if pointDistance<opRange(1)
        outliersIndices=[outliersIndices; i];
    else
        inliersIndices=[inliersIndices; i];
    end
end

end

