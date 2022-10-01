function [p_m] = myProjection_v3(p_h,Tm_h)
%MYPROJECTION Projects from p_h to p_m using the transformatio matrix Tm_h
N=p_h.Count;
for i=1:N
    proj=Tm_h*[p_h.Location(i,:) 1]';
    xyz(i,:)=proj(1:3)';
end
    p_m= pointCloud(xyz);%
end

