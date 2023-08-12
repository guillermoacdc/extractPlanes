function [j_unit, p0] = compute_jvector_pc(p1, p2, A, B, C, L2, originFlag)
%COMPUTE_JVECTOR_PC Computes a vector j_unit parallel to y-axis and the origin
%of coordinate system p0
%   Detailed explanation goes here
pc=computeCentralPoint(p1,p2);
% compute unit vector paralle to y axis
j_unit=cross([A, B, C],(p1-p2));
% normalize j_unit
modj=norm(j_unit);
j_unit=j_unit'/modj;
if originFlag
    p0=pc-(L2/2)*j_unit;
else
    p0=pc+(L2/2)*j_unit;
end
end

