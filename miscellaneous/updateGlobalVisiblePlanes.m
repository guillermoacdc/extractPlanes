function updatedGlobalVisiblePlanes = updateGlobalVisiblePlanes(globalVisiblePlanes,extractedBoxesID)
%UPDATEGLOBALVISIBLEPLANES Eliminates extracted planes from the glboal
%visible planes vector
%   Detailed explanation goes here
NextractedBoxes=length(extractedBoxesID);
indexExtractedPlane=[];
if NextractedBoxes==0
    updatedGlobalVisiblePlanes=globalVisiblePlanes;
else
    for i=1:NextractedBoxes
        extractedBox=extractedBoxesID(i);
        indexTemp=find(globalVisiblePlanes(:,1)==extractedBox);
        if ~isempty(indexTemp)
            indexExtractedPlane=[indexExtractedPlane, indexTemp];
        end
    end
    updatedGlobalVisiblePlanes=globalVisiblePlanes;
    updatedGlobalVisiblePlanes(indexExtractedPlane,:)=[];
end

end

