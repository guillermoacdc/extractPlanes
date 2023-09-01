function [planeDesc_h] = projectPose(planeDesc_m,Tm2h)
%PROJECTPOSE Summary of this function goes here
%   Detailed explanation goes here
planeDesc_h=planeDesc_m;
Nb=size(planeDesc_m,2);
for i=1:Nb
    planeDesc_h(i).tform=Tm2h*planeDesc_m(i).tform;
    planeDesc_h(i).unitNormal=planeDesc_h(i).tform(1:3,3);
end
end

