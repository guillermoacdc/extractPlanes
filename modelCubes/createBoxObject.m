function [myBox] = createBoxObject(myPlanes,boxIDs,id)
%CREATEBOXOBJECT Summary of this function goes here
%   Detailed explanation goes here

% compute D, H, W
[depth height width]=projectInEdge_v2(myPlanes,boxIDs);
% Compute pose
T=myPlanes.(['fr' num2str(boxIDs(1))])(boxIDs(2)).tform;
% create box object
myBox=detectedBox(id, depth, height,width, T, boxIDs);
% fill box property in plane objects
myPlanes.(['fr' num2str(boxIDs(1))])(boxIDs(2)).idBox=id;
myPlanes.(['fr' num2str(boxIDs(3))])(boxIDs(4)).idBox=id;
myPlanes.(['fr' num2str(boxIDs(5))])(boxIDs(6)).idBox=id;
end

