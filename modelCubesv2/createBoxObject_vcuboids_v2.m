function [myBox] = createBoxObject_vcuboids_v2(globalPlanes,triadIndex, sessionID, frameID)
%CREATEBOXOBJECT Creates a box object from groups of planes. The groups can
%be composed by two or three plane segments
% initiate myBox as an empty object
emptyBoxObject=detectedBox(0,0,0,0,eye(4),[0 0 0],[0 0 0]);
% myBox=emptyBoxObject;
% myBox=[];
% parameters
compensateHeight=50;%milimeters; associated with the threshold in the stage of floor-remotion; update this variable with input argument 

% compute side triad and complement in cases of groups with size two
if length(triadIndex)>2
    % compute grouped sides in the triad; assumption: element 1 is side 0
    sideElement2=computeSidesInTriad(globalPlanes,triadIndex(1),triadIndex(2));
    sideElement3=computeSidesInTriad(globalPlanes,triadIndex(1),triadIndex(3));
    sideTriad=[0 sideElement2 sideElement3];
    sideTriadRepetitions=checkRepetitions(sideTriad);
%     return if there are repeated sides in sideTriad
    if sideTriadRepetitions
        myBox=emptyBoxObject;
        return
    end
    syntheticPlaneFlag=false;
else
    [estimatedSyntheticPlane, sideTriad] = computeEstimatedSyntheticLateralPlane(globalPlanes,...
    triadIndex, sessionID, frameID);
    N=length(globalPlanes);
    globalPlanes=[globalPlanes, estimatedSyntheticPlane];
    triadIndex=[triadIndex N+1];
    syntheticPlaneFlag=true;
end

% [width, depth, height]=computeBoxLength_v2(globalPlanes,triadIndex);
[width, depth, height]=computeBoxLength(globalPlanes,triadIndex,sideTriad);
[height, width, depth, idBox]=refinateBoxLength(width, depth, height,...
    compensateHeight, sessionID, frameID);

% adjust pose until obtain orthogonality
if syntheticPlaneFlag
%     compute yaw with two planes
    yaw=computeYaw(globalPlanes,triadIndex(1:2), sideTriad(1:2));
else
%     compute yaw with three planes
    yaw=computeYaw(globalPlanes,triadIndex, sideTriad);%rotation around y axis
end
globalPlanes(triadIndex(1)).tform(1:3,1:3)=roty(yaw)*globalPlanes(triadIndex(1)).tform(1:3,1:3);

adjustPoseOrthogonal_v3(globalPlanes,triadIndex, sideTriad);

%% Refinate pose

T=globalPlanes(triadIndex(1)).tform;% se asume que el primer plano es top
% create box object
myBox=detectedBox(idBox, depth, height,width, T, triadIndex, sideTriad);
% fill box property in plane objects
globalPlanes(triadIndex(1)).idBox=idBox;
globalPlanes(triadIndex(2)).idBox=idBox;
globalPlanes(triadIndex(3)).idBox=idBox;
end

