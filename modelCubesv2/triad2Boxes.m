function [myBox, newGroup_tp]=triad2Boxes(globalPlanes,triadIndex, ...
            sessionID, frameID, pkFlag,idBox, compensateHeight, th_angle)
%TRIAD2BOXES Transform a triad of plane segment to a box object
%   Detailed explanation goes here
emptyBoxObject=detectedBox(0,0,0,0,eye(4),[0 0 0],[0 0 0]);
newGroup_tp=[];
% compute side vector
sideA=computeSideInCouple(globalPlanes,triadIndex(1), triadIndex(2), th_angle);
sideB=computeSideInCouple(globalPlanes,triadIndex(1), triadIndex(3), th_angle);
sideVector=[0, sideA, sideB];

consFlag=checkSideConsistency(sideVector);

if consFlag
    boxPose=computeBoxPose(globalPlanes,triadIndex,sideVector);
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
else
    myBox=emptyBoxObject;
    newGroup_tp=triadIndex(1);
end

end

