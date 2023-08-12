function [tform] = computeTformBox(p1,p2,A,B,C,L2,H, originFlag)
%COMPUTETFORMBOX Comnputes groundtruth pose of a box, from inputs
% p1,p2, points of two corners in the superior plane
% [A,B,C] plane normal
% [L2,H] box size L2, height H

p1p=projectSinglePoint2Plane(p1,A,B,C,-H);
p2p=projectSinglePoint2Plane(p2,A,B,C,-H);
[j_unit, p0] = compute_jvector_pc(p1p, p2p, A, B, C, L2, originFlag);
% compute vector parallel to axis x
i_unit=p1p-p2p;
i_unit=i_unit/norm(i_unit);

tform=eye(4);
tform(1:3,1)=i_unit; %or cross([A B C]',j_unit);
tform(1:3,2)=j_unit;
tform(1:3,3)=[A B C]';
tform(1:3,4)=p0;
end

