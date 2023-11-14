function visibleBoxes = computeVisibleBoxesByFrame(visiblePlanesByFrame)
%COMPUTEVISIBLEBOXESBYFRAME Returns an vector with the id of visible boxes
% Assumption: A box is visible when a top face and one or mor lateral faces
% are visible

visibleBoxes=[];
Nb=size(visiblePlanesByFrame,1);

for i=1:Nb
    boxID=visiblePlanesByFrame(i).boxID;
    planes=visiblePlanesByFrame(i).planesID;
    idx=find(planes==1);%find a top plane
    if ~isempty(idx)
        if length(planes)>1
            visibleBoxes=[visibleBoxes boxID];
        end
    end
end

end

