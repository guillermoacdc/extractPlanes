function [globalBoxes] = couples2boxes(globalPlanes, tp,...
    pkflag, th_ground, th_angle, sessionID, frameID)
%COUPLES2BOXES Converts a set of couples into a set of box objects
% tp: vector where each element point to a top plane segment ps in globalPlanes.
% This element has a second plane different than null. tp is for top,
% perpendicular
% pkflag: previous knowledge flag
% th_ground: threshold used in the plane detection stage to remove the
% ground
% th_angle: threshold to approximate orthogonal relationships btwn angles
% warning
% this function modifies globalPlanes vector. writes on boxID field
% adds synthetic planes to the end of the globalPlanes vector

% initiate an empty boxes vector
emptyBoxObject=detectedBox(0,0,0,0,eye(4),[0 0 0],[0 0 0]);
globalBoxes=emptyBoxObject;
globalBoxes(1)=[];

Ncouples=length(tp);

idBox=1;
if Ncouples>=1
    for iCouples=1:Ncouples
        coupleIndex=computeCoupleIndex(globalPlanes,tp(iCouples));
        sideL=computeSideInCouple(globalPlanes.values,coupleIndex(1),coupleIndex(2),...
            th_angle);
        boxPose=compute6DBoxPose(coupleIndex,globalPlanes,[0 sideL]);
        [psx, sideBoxID]=computeSyntheticPlaneSegment_v2(globalPlanes,...
            coupleIndex,sessionID,frameID,sideL,boxPose);
%         globalPlanes.push(psx);
        tempObj.values=psx;
        syntheticPlaneSegment_struct=myObj2Struct(tempObj);
        globalPlanes.values=[globalPlanes.values; syntheticPlaneSegment_struct.values];%warning: modification of global planes vector

        triadIndex=[coupleIndex length(globalPlanes.values)];
        boxSize=compute3DBoxSize(triadIndex,globalPlanes.values,sideBoxID,...
            th_ground,pkflag, sessionID, frameID);
%       create object box and accumulate objects
        boxTform=eye(4);
        boxTform(1:3,4)=boxPose.t;
        boxTform(1:3,1:3)=boxPose.R;
        myBox=detectedBox(idBox, boxSize.depth, boxSize.height, ...
                boxSize.width, boxTform, coupleIndex, sideBoxID);%consider use triadIndex instead of coupleIndex to track the synthetic plane
        idBox=idBox+1;
        globalBoxes=[globalBoxes myBox];
%       modify boxID field in global planes
        globalPlanes.values(triadIndex(1)).idBox=idBox;
        globalPlanes.values(triadIndex(2)).idBox=idBox;
        globalPlanes.values(triadIndex(3)).idBox=idBox;
    end
end

end



