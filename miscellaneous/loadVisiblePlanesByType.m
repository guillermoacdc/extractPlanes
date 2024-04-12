function visiblePlanesVector = loadVisiblePlanesByType(fileName,sessionID, frameID, planeType)
%LOADVISIBLEPLANESBYTYPE Loads visible planes by type
% type      Descripton
% 0         top planes
% 1         lateral planes
% 2         all planes
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
if planeType<2
    idx=find(visiblePlanesVectorAll(:,2)==1);
    if planeType==0 %top planes
    % delete lateral planes
        idxs=1:Nplanes;
        idx=setdiff(idxs,idx);
        visiblePlanesVector(idx,:)=[];
    else
    % delete top planes
        visiblePlanesVector(idx,:)=[];
    end
end

end

