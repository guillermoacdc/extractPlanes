function [estimatedSyntheticPlane, sideTriad, syntheticSide] = computeEstimatedSyntheticLateralPlane(globalPlanes,...
    group_tp, sessionID, frameID)
%COMPUTEESTIMATEDSYNTHETICLATERALPLANE Computes a plane object from an
% input composed by a couple of plane objects
% The couple of plane objects is indexed by the group_tp input
% The first element of the couple is a top plane, the second element is a
% perpendicular plane
% 
% The output is composed by
% The object estimatedSyntheticPlane with descriptors of the derived plane.
% The index in this object has a common value (-1)
% The sideTriad vector with three elements that indicates the side of each
% component of the triad. The last element corresponds with the synthetic
% plane
% syntheticSide is the side of the synthetic plane


% compute side of the perpendicular plane at input
sideElement2=computeSidesInTriad(globalPlanes,group_tp(1), group_tp(2));

%% compute lengths of output plane (L1, L2)
if globalPlanes(group_tp(2)).L2toY
    La=globalPlanes(group_tp(2)).L2;
else
    La=globalPlanes(group_tp(2)).L1;
end

if sideElement2==1 | sideElement2==3
    Lb=globalPlanes(group_tp(1)).L1;
else
    Lb=globalPlanes(group_tp(1)).L2;
end

if La>Lb
    L2=La;
    L1=Lb;
    L2toY=1;
else
    L2=Lb;
    L1=La;
    L2toY=0;
end

%% compute tform of output plane
tform=globalPlanes(group_tp(1)).tform;
% compute rotation 
if sideElement2==1 | sideElement2==3
    tform(1:3,1:3)=roty(90)*tform(1:3,1:3);%
else
    tform(1:3,1:3)=eye(3)*tform(1:3,1:3);%there is no rotation
end 
% compute normal and position. Warning: coordinate systems in estimated 
% planes will have 180 deg btwn normal and z vector for cases 3, 4
position=globalPlanes(group_tp(1)).tform(1:3,4);
L1top=globalPlanes(group_tp(1)).L1;
L2top=globalPlanes(group_tp(1)).L2;
switch sideElement2
    case 1
        syntheticSide=2;
        n=globalPlanes(group_tp(1)).tform(1:3,1);
        position=position+L2top/2*n;
    case 2
        syntheticSide=1;
        n=globalPlanes(group_tp(1)).tform(1:3,3);
%         displacement in normal direction
        position=position+L1top/2*n;
    case 3
        syntheticSide=4;
        n=-globalPlanes(group_tp(1)).tform(1:3,1);
        position=position+L2top/2*n;
    case 4
        syntheticSide=3;
        n=-globalPlanes(group_tp(1)).tform(1:3,3);
        position=position+L1top/2*n;
end
sideTriad=[0 sideElement2, syntheticSide];
%         displacement in gravity vector direction
position=position-La/2*globalPlanes(group_tp(1)).tform(1:3,2);
tform(1:3,4)=position;
%% compute parameter D of output plane
D=dot(-n,position);
%% create output plane object
modelParameters=[n', D, position'];
pathInliers=[];
Nmbinliers=[];
indexForSyntheticPlane=-1;
estimatedSyntheticPlane=plane(sessionID,frameID,indexForSyntheticPlane,modelParameters,pathInliers,Nmbinliers);
estimatedSyntheticPlane.L1=L1;
estimatedSyntheticPlane.L2=L2;
estimatedSyntheticPlane.L2toY=L2toY;
estimatedSyntheticPlane.tform=tform;
end

