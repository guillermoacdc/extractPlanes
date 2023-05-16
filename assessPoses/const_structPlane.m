function [plane] = const_structPlane(planeLengths,T)
%CONST_STRUCTPLANE Summary of this function goes here
%   Detailed explanation goes here
plane.L1=planeLengths(1);
plane.L2=planeLengths(2);
plane.H=planeLengths(3);
plane.tform=T;
% to plot contorn with preexisted functions 
plane.planeTilt=1;
plane.L2toY=1;
end

