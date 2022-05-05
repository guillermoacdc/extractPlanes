function [xmax ymax zmax i_x i_y i_z] = computeFartherPointv3(pc)
%COMPUTEFARTHERPOINT Summary of this function goes here
%   Assumptions: 
% * pc is centered in the origin of q_ref

xComponents=pc.Location(:,1);
yComponents=pc.Location(:,2);
zComponents=pc.Location(:,3);

[xmax i_x]=max(xComponents);%greater projection on edge x
[ymax i_y]=max(yComponents);%greater projection on edge y
[zmax i_z]=max(zComponents);%greater projection on edge z

end

