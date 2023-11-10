function [myBox] = createBoxObject_vtriads(globalPlanes,triadIndex, sessionID, frameID)
%CREATEBOXOBJECT Summary of this function goes here
%   Detailed explanation goes here
compensateHeight=50;%milimeters; associated with the threshold in the stage of floor-remotion; update this variable with input argument 

% compute grouped sides in the triad; assumption: element 1 is side 0
sideElement2=computeSidesInTriad(globalPlanes,triadIndex(1),triadIndex(2));
sideElement3=computeSidesInTriad(globalPlanes,triadIndex(1),triadIndex(3));
sideTriad=[0 sideElement2 sideElement3];
% adjust pose until obtain orthogonality
% adjustPoseOrthogonal(globalPlanes,triadIndex);
adjustPoseOrthogonal_v3(globalPlanes,triadIndex, sideTriad);

% compute W, D, H; raw version
[width, depth, height]=projectInEdge_vcuboids(globalPlanes,triadIndex);

%% refinate W, D, H, based on previous knowledge of box size
% first modification associated with compensation of height
height=height+compensateHeight;
% second modification using the nearest neighborhood 
[width, depth, height, idBox]=updateLengthWithNearestNeighborhood([width, depth, height], sessionID, frameID);

%% Refinate pose
T=globalPlanes(triadIndex(1)).tform;% se asume que el primer plano es top
% create box object
myBox=detectedBox(idBox, depth, height,width, T, triadIndex, sideTriad);
% fill box property in plane objects
globalPlanes(triadIndex(1)).idBox=idBox;
globalPlanes(triadIndex(2)).idBox=idBox;
globalPlanes(triadIndex(3)).idBox=idBox;
end

