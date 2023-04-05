function [p_m] = myProjection_v4(p_h,Tm_h)
%MYPROJECTION Projects from p_h to p_m using the transformatio matrix Tm_h
% Assumptions: height in y axis
N=p_h.Count;
for i=1:N
    proj=Tm_h*[p_h.Location(i,1) p_h.Location(i,3) p_h.Location(i,2) 1]';
    xyz(i,:)=proj(1:3)';
end
    p_m= pointCloud(xyz);%
end

