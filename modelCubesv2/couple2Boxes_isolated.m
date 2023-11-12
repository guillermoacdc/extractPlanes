function myBox=couple2Boxes_isolated(globalPlanes,coupleIndex, ...
            sessionID, frameID, pkFlag,idBox, compensateHeight, th_angle)
%COUPLE2BOXES Transform a couple of plane segment to a box object
%   Detailed explanation goes here

% compute side vector
sideA=computeSideInCouple(globalPlanes,coupleIndex(1), coupleIndex(2), th_angle);
sideVector=[0, sideA];
% compute box pose
boxPose=computeBoxPose(globalPlanes,coupleIndex,sideVector);
% compute synthetic plane
[syntheticPlaneSegment, sideSynthetic]=computeSyntheticPlaneSegment(globalPlanes,...
    coupleIndex, sessionID, frameID, sideA, boxPose);

% create triad
sideVector=[0, sideA, sideSynthetic];

tempObj.values=syntheticPlaneSegment;
syntheticPlaneSegment_struct=myObj2Struct(tempObj);
globalPlanes=[globalPlanes; syntheticPlaneSegment_struct.values];%warning: modification of global planes vector

syntheticIndex=length(globalPlanes);
triadIndex=[coupleIndex, syntheticIndex];
% compute length
[width, depth, height]=computeBoxLength(globalPlanes,triadIndex,sideVector);
%     refinate length
if pkFlag
    [height, width, depth]=refinateBoxLength(width, depth, height,...
    compensateHeight, sessionID, frameID);
else
    height=height+compensateHeight;
end
% create box object
myBox=detectedBox(idBox, depth, height,width, boxPose, triadIndex, sideVector);
% fill box property in plane objects
globalPlanes(triadIndex(1)).idBox=idBox;
globalPlanes(triadIndex(2)).idBox=idBox;
globalPlanes(triadIndex(3)).idBox=idBox;



end

