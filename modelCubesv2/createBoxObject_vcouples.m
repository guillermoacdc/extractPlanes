function [myBox] = createBoxObject_vcouples(globalPlanes,coupleIndex, sessionID, frameID)
%CREATEBOXOBJECT Create a box object from a couple of orthogonal planes
% Assumption
% The first plane in the couple is a top plane
% 
%   Parameters
compensateHeight=50;%milimeters; associated with the threshold in the stage of floor-remotion; update this variable with input argument 

% create a third box object to complement the couple into a triad
[estimatedSyntheticPlane, sideTriad] = computeEstimatedSyntheticLateralPlane(globalPlanes,...
    group_tp, sessionID, frameID);
globalPlanesTemporal=[globalPlanes(coupleIndex(1)), globalPlanes(coupleIndex(2)),...
    estimatedSyntheticPlane];
triadIndex=1:3;

% adjust pose until obtain orthogonality
% adjustPoseOrthogonal(globalPlanes,coupleIndex);
adjustPoseOrthogonal_v3(globalPlanesTemporal, triadIndex, sideTriad);

% compute W, D, H; raw version
% [width, depth, height]=projectInEdge_vcuboids(globalPlanesTemporal,coupleIndex);
[width, depth, height]=projectInEdge_vcouples(globalPlanesTemporal,coupleIndex);

%% refinate W, D, H, based on previous knowledge of box size
% first modification associated with compensation of height
height=height+compensateHeight;
% second modification using the nearest neighborhood 
[width, depth, height, idBox]=updateLengthWithNearestNeighborhood([width, depth, height], sessionID, frameID);

%% Refinate pose
T=globalPlanes(coupleIndex(1)).tform;% se asume que el primer plano es top
% create box object
myBox=detectedBox(idBox, depth, height,width, T, coupleIndex, sideTriad);
% fill box property in plane objects
globalPlanes(coupleIndex(1)).idBox=idBox;
globalPlanes(coupleIndex(2)).idBox=idBox;
globalPlanes(coupleIndex(3)).idBox=idBox;
end

