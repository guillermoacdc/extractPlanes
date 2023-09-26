function [p_m] = myProjection_v4(p_h,Th2m)
%MYPROJECTION Projects from p_h to p_m using the transformatio matrix Th2m
% Assumptions: height in y axis
% note: use v3; this one was exploratory
N=p_h.Count;
for i=1:N
    proj=Th2m*[p_h.Location(i,1) p_h.Location(i,3) p_h.Location(i,2) 1]';
    xyz(i,:)=proj(1:3)';
end
    p_m= pointCloud(xyz);%
end

