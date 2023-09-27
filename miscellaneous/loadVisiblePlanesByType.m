function visiblePlanesVector = loadVisiblePlanesByType(fileName,sessionID, frameID, planeType)
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

% filter vector based on plane type
visiblePlanesVector=visiblePlanesVectorAll;
idx=find(visiblePlanesVectorAll(:,2)==1);
if planeType==0 %top planes
% delete lateral planes
    idxs=[1:Nplanes];
    idx=setdiff(idxs,idx);
    visiblePlanesVector(idx,:)=[];
else
% delete top planes
    visiblePlanesVector(idx,:)=[];
end

end

