function [globalBoxes,remainingGroups] = triads2boxes(globalPlanes, tpp,...
    pkflag, th_ground, th_angle, sessionID, frameID)
%TRIADS2BOXES Converts a set of triads into a set of box objects
% tpp: vector where each element point to a top plane segment ps in globalPlanes.
% This element has a second and third plane different than null. tpp is for top,
% perpendicular, perpendicular 
% pkflag: previous knowledge flag
% th_ground: threshold used in the plane detection stage to remove the
% ground
% th_angle: threshold to approximate orthogonal relationships btwn angles
% warning
% this function modifies globalPlanes vector. writes on boxID field

% initiate en empty boxes vector
emptyBoxObject=detectedBox(0,0,0,0,eye(4),[0 0 0],[0 0 0]);
globalBoxes=emptyBoxObject;
globalBoxes(1)=[];

Ntriads=length(tpp);
remainingGroups=[];
idBox=1;
if Ntriads>=1
    for iTriads=1:Ntriads
        triadIndex=computeTriadIndex(globalPlanes,tpp(iTriads));
        sideBoxID=computeSideInTriad(globalPlanes.values,triadIndex(1),triadIndex(2),...
            triadIndex(3),th_angle);
        consFlag=checkSideConsistency(sideBoxID);
        if consFlag
            boxPose=compute6DBoxPose(triadIndex,globalPlanes,sideBoxID);
            boxSize=compute3DBoxSize(triadIndex,globalPlanes.values,sideBoxID,...
                th_ground,pkflag, sessionID, frameID);
%             create object box and accumulate objects
            boxTform=eye(4);
            boxTform(1:3,4)=boxPose.t;
            boxTform(1:3,1:3)=boxPose.R;
            myBox=detectedBox(idBox, boxSize.depth, boxSize.height, ...
                boxSize.width, boxTform, triadIndex, sideBoxID);
            idBox=idBox+1;
            globalBoxes=[globalBoxes myBox];
%             modify boxID field in global planes
            globalPlanes.values(triadIndex(1)).idBox=idBox;
            globalPlanes.values(triadIndex(2)).idBox=idBox;
            globalPlanes.values(triadIndex(3)).idBox=idBox;
        else
            remainingGroups=[remainingGroups, tpp(iTriads)];
        end
    end
else
    globalBoxes=[];
    remainingGroups=[];
end

end

