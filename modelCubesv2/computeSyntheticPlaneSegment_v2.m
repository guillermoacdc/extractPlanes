function [syntheticPlaneSegment, sideTriad, lateralSideID_psx]=computeSyntheticPlaneSegment_v2(globalPlanes,...
    coupleIndex, sessionID, frameID, sideElement2, boxPose)
%COMPUTESYNTHETICPLANESEGMENT_v2 Computes a plane object from an
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
if globalPlanes.values(coupleIndex(2)).L2toY
    La=globalPlanes.values(coupleIndex(2)).L2;
else
    La=globalPlanes.values(coupleIndex(2)).L1;
end

if sideElement2==1 | sideElement2==3
    Lb=globalPlanes.values(coupleIndex(1)).L1;
else
    Lb=globalPlanes.values(coupleIndex(1)).L2;
end

if La>Lb
    psx.L2=La;
    psx.L1=Lb;
    psx.L2toY=1;
else
    psx.L2=Lb;
    psx.L1=La;
    psx.L2toY=0;
end

%% compute tform of output plane
psx.R=boxPose.R;
psx.t=boxPose.t;
% compute rotation 
if sideElement2==1 | sideElement2==3
    lateralSideID_psx=2;
    psx.n=boxPose.R(:,1);
    psx.t=psx.t+psx.n*globalPlanes.values(coupleIndex(1)).L2/2 ...
            -La*boxPose.R(:,2)/2;
    psx.R=roty(90)*psx.R;
else
    lateralSideID_psx=1;
    psx.n=boxPose.R(:,3);
    psx.t=psx.t+psx.n*globalPlanes.values(coupleIndex(1)).L1/2 ...
            -Lb*boxPose.R(:,2)/2;
end 
sideTriad=[0, sideElement2, lateralSideID_psx];
%% compute parameter D of output plane
psx.D=dot(-psx.n,psx.t);
%% create output plane object
modelParameters=[psx.n', psx.D, psx.t'];
pathInliers=[];
Nmbinliers=[];
indexForSyntheticPlane=-1;
syntheticPlaneSegment=plane(sessionID,frameID,indexForSyntheticPlane,modelParameters,pathInliers,Nmbinliers);
syntheticPlaneSegment.L1=psx.L1;
syntheticPlaneSegment.L2=psx.L2;
syntheticPlaneSegment.L2toY=psx.L2toY;
tform=eye(4);
tform(1:3,3)=psx.t;
tform(1:3,1:3)=psx.R;
syntheticPlaneSegment.tform=tform;

end

