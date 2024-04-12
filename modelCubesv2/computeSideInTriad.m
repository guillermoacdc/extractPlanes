function [sideInTriad] = computeSideInTriad(globalPlanes,indextop, indexperp1,indexperp2,th_angle)
%COMPUTESIDEINTRIAD Computes the side of perpendicular plane from a triad
% of planes. The side is codified as explained in computeSideInCouple.m

side1=computeSideInCouple(globalPlanes,indextop, indexperp1, th_angle);
side2=computeSideInCouple(globalPlanes,indextop, indexperp2, th_angle);
sideInTriad=[0 side1 side2];
end