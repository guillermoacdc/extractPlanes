function box = compute3DBoxSize(triadIndex,globalPlanes, ...
    sideBoxID, th_ground, pkFlag, sessionID, frameID)
%COMPUTE3DBOXSIZE computes a structure with name box and fields: height,
%width and depth
% triadIndex: vector with indexes that point to globalPlanes and conform a
% triad
% globalPlane: vector with plane objects
% sideBoxID: vector with ID of box side for each element in the triad
% th_ground: parameter used in the plane detection stage and reused in this
% stage to compensate height of lateral planes
% pkFlag: flag to enable the refinate of size stage

%% compute box size
% height
p1Height=computeBoxHeightFromPerpPlane(globalPlanes(triadIndex(2)));
p2Height=computeBoxHeightFromPerpPlane(globalPlanes(triadIndex(3)));
box.height=mean([p1Height,p2Height])+th_ground;
% width
idx=find(sideBoxID==1);
if isempty(idx)
    idx=find(sideBoxID==3);
end
paWidth=computeBoxWidthFromPerpPlane(globalPlanes(triadIndex(idx)));
ptopWidth=globalPlanes(triadIndex(1)).L2;
box.width=mean([paWidth, ptopWidth]);

% depth
idx=find(sideBoxID==2);
if isempty(idx)
    idx=find(sideBoxID==4);
end
paDepth=computeBoxWidthFromPerpPlane(globalPlanes(triadIndex(idx)));
ptopDepth=globalPlanes(triadIndex(1)).L1;
box.depth=mean([paDepth, ptopDepth]);

%% conditional adjust of size
if pkFlag 
    box=refinateBoxSize(box, sessionID, frameID);%Here box has an addition field: box.id
end

end

