function flag = gcRelationshipCheck_v2(targetPlane, candidatePlane)
%GCRELATIONSHIPCHECK Computes a flag of relationships between geometric
%center of target and candidate plane
%   Detailed explanation goes here
% Assumption: target is a top plane and candidate is a perpendicular plane
th_angle=18;%in degrees; update to be an input argument
%height of top planes is > height of perpendicular plane; heigth data is in y axis
c1=targetPlane.geometricCenter(2)>candidatePlane.geometricCenter(2);
% xtop=targetPlane.tform(1:3,1);
% ztop=targetPlane.tform(1:3,3);
% zcandidate=candidatePlane.tform(1:3,3);
% alphaxz=computeAngleBtwnVectors(xtop,zcandidate);
% alphazz=computeAngleBtwnVectors(ztop,zcandidate);

if  candidatePlane.planeTilt
    c2=(targetPlane.limits(1)<candidatePlane.geometricCenter(1)) &...
        (candidatePlane.geometricCenter(1)<targetPlane.limits(2));
else
    c2=(targetPlane.limits(5)<candidatePlane.geometricCenter(3)) &...
        (candidatePlane.geometricCenter(3)<targetPlane.limits(6));
end

flag=c1 & c2;
end

