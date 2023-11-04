function [myBox] = createBoxObject_vcuboids(globalPlanes,group_tpp, sessionID, frameID)
%CREATEBOXOBJECT Summary of this function goes here
%   Detailed explanation goes here
compensateHeight=50;%milimeters; associated with the threshold in the stage of floor-remotion; update this variable with input argument 

% compute grouped sides in the triad; assumption: element 1 is side 0
sideElement2=computeSidesInTriad(globalPlanes,group_tpp(1),group_tpp(2));
sideElement3=computeSidesInTriad(globalPlanes,group_tpp(1),group_tpp(3));
sideTriad=[0 sideElement2 sideElement3];
% adjust pose until obtain orthogonality
% adjustPoseOrthogonal(globalPlanes,group_tpp);
adjustPoseOrthogonal_v3(globalPlanes,group_tpp, sideTriad);

% compute W, D, H; raw version
[width, depth, height]=projectInEdge_vcuboids(globalPlanes,group_tpp);

%% refinate W, D, H, based on previous knowledge of box size
% first modification associated with compensation of height
height=height+compensateHeight;
% second modification using the nearest neighborhood 
[width, depth, height, idBox]=updateLengthWithNearestNeighborhood([width, depth, height], sessionID, frameID);

%% Compute pose
T=globalPlanes(group_tpp(1)).tform;% se asume que el primer plano es top
% create box object
myBox=detectedBox(idBox, depth, height,width, T, group_tpp, sideTriad);
% fill box property in plane objects
globalPlanes(group_tpp(1)).idBox=idBox;
globalPlanes(group_tpp(2)).idBox=idBox;
globalPlanes(group_tpp(3)).idBox=idBox;
end

