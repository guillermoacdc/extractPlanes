function [width, depth, height]=computeBoxLength(globalPlanes,triadIndex, sideTriad)
%COMPUTEBOXLENGTH Computes the laength of a box composed by three
%orthogonal planes. The computation is based on L1, L2 properties of each
%plane
% Assumptions: the first plane in the set triadIndex is a top plane


% height
p1Height=computeBoxHeightFromPerpPlane(globalPlanes(triadIndex(2)));
p2Height=computeBoxHeightFromPerpPlane(globalPlanes(triadIndex(3)));
height=mean([p1Height,p2Height]);
% width
idx=find(sideTriad==1);
if isempty(idx)
    idx=find(sideTriad==3);
end
paWidth=computeBoxWidthFromPerpPlane(globalPlanes(triadIndex(idx)));
ptopWidth=globalPlanes(triadIndex(1)).L2;
width=mean([paWidth, ptopWidth]);

% depth
idx=find(sideTriad==2);
if isempty(idx)
    idx=find(sideTriad==4);
end
paDepth=computeBoxWidthFromPerpPlane(globalPlanes(triadIndex(idx)));
ptopDepth=globalPlanes(triadIndex(1)).L1;
depth=mean([paDepth, ptopDepth]);


end

