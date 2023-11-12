function [syntheticPlaneSegment, sideSynthetic]=computeSyntheticPlaneSegment(globalPlanes,...
    coupleIndex, sessionID, frameID, sideElement2, boxPose)
%COMPUTESYNTHETICPLANESEGMENT Computes a plane object from an
% input composed by a couple of plane objects
% The couple of plane objects is indexed by the coupleIndex input
% The first element of the couple is a top plane, the second element is a
% perpendicular plane
% 
% The output is composed by
% The object syntheticPlaneSegment with descriptors of the derived plane.
% The sideTriad vector with three elements that indicates the side of each
% component of the triad. The last element corresponds with the synthetic
% plane
% sideSynthetic is the side of the synthetic plane in the format
% 1. for plane located in the positive direction of ztop
% 2. for plane located in the positive direction of xtop
% 3. for plane located in the negative direction of ztop
% 4. for plane located in the negative direction of xtop 

% compute side of the perpendicular plane at input
% sideElement2=computeSidesInTriad(globalPlanes,coupleIndex(1), coupleIndex(2));

%% compute lengths of output plane (L1, L2)
if globalPlanes(coupleIndex(2)).L2toY
    La=globalPlanes(coupleIndex(2)).L2;
else
    La=globalPlanes(coupleIndex(2)).L1;
end

if sideElement2==1 | sideElement2==3
    Lb=globalPlanes(coupleIndex(1)).L1;
else
    Lb=globalPlanes(coupleIndex(1)).L2;
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
tform=boxPose;
% compute rotation 
if sideElement2==1 | sideElement2==3
    tform(1:3,1:3)=roty(90)*tform(1:3,1:3);%
else
    tform(1:3,1:3)=eye(3)*tform(1:3,1:3);%there is no rotation
end 
% compute normal and position. Warning: coordinate systems in estimated 
% planes will have 180 deg btwn normal and z vector for cases 3, 4
position=globalPlanes(coupleIndex(1)).tform(1:3,4);
L1top=globalPlanes(coupleIndex(1)).L1;
L2top=globalPlanes(coupleIndex(1)).L2;
switch sideElement2
    case 1
        sideSynthetic=2;
        n=globalPlanes(coupleIndex(1)).tform(1:3,1);
        position=position+L2top/2*n;
    case 2
        sideSynthetic=1;
        n=globalPlanes(coupleIndex(1)).tform(1:3,3);
%         displacement in normal direction
        position=position+L1top/2*n;
    case 3
        sideSynthetic=4;
        n=-globalPlanes(coupleIndex(1)).tform(1:3,1);
        position=position+L2top/2*n;
    case 4
        sideSynthetic=3;
        n=-globalPlanes(coupleIndex(1)).tform(1:3,3);
        position=position+L1top/2*n;
end

%         displacement in gravity vector direction
position=position-La/2*globalPlanes(coupleIndex(1)).tform(1:3,2);
tform(1:3,4)=position;
%% compute parameter D of output plane
D=dot(-n,position);
%% create output plane object
modelParameters=[n', D, position'];
pathInliers=[];
Nmbinliers=[];
indexForSyntheticPlane=-1;
syntheticPlaneSegment=plane(sessionID,frameID,indexForSyntheticPlane,modelParameters,pathInliers,Nmbinliers);
syntheticPlaneSegment.L1=L1;
syntheticPlaneSegment.L2=L2;
syntheticPlaneSegment.L2toY=L2toY;
syntheticPlaneSegment.tform=tform;

end

