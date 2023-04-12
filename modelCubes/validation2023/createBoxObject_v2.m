function [myBox] = createBoxObject_v2(myPlanes,boxIDs,id)
%CREATEBOXOBJECT Summary of this function goes here
%   Detailed explanation goes here
% _v2 uses the structure planesDescriptor with the fields (1) camerapose, (2) values

% compute D, H, W
[depth height width]=projectInEdge_v3(myPlanes,boxIDs);
% Compute pose
T=myPlanes.(['fr' num2str(boxIDs(1))]).values(boxIDs(2)).tform;
% create box object
myBox=detectedBox(id, depth, height,width, T, boxIDs);
% fill box property in plane objects
myPlanes.(['fr' num2str(boxIDs(1))]).values(boxIDs(2)).idBox=id;
myPlanes.(['fr' num2str(boxIDs(3))]).values(boxIDs(4)).idBox=id;
myPlanes.(['fr' num2str(boxIDs(5))]).values(boxIDs(6)).idBox=id;
end

