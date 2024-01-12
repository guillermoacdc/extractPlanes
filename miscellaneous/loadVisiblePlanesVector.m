function visiblePlanesVectorAll = loadVisiblePlanesVector(fileName,sessionID, frameID)
%LOADVISIBLEPLANESBYTYPE Summary of this function goes here
%   Detailed explanation goes here
visiblePlanesByFrame = loadVisiblePlanes(fileName,sessionID, frameID);
% convert struct to vector
Nplanes=countPlanes(visiblePlanesByFrame);
visiblePlanesVectorAll=zeros(Nplanes,2);
Nboxes=size(visiblePlanesByFrame,1);
k=1;
for i=1:Nboxes
    N=length(visiblePlanesByFrame(i).planesID);
    for j=1:N
        visiblePlanesVectorAll(k,:)=[visiblePlanesByFrame(i).boxID, visiblePlanesByFrame(i).planesID(j)];
        k=k+1;
    end
end



end

