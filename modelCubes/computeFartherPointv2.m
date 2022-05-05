function [pa_max pb_max pc_max i_a, i_b, i_c] = computeFartherPointv2(p0,pc, na, nb, nc)
%COMPUTEFARTHERPOINT Summary of this function goes here
%   Detailed explanation goes here
% size(n)=3x1
% size(p0)=3x

for i=1:pc.Count
    projected_a(i)=((pc.Location(i,:)-p0') *na);
    projected_b(i)=((pc.Location(i,:)-p0') *nb);
    projected_c(i)=((pc.Location(i,:)-p0') *nc);
end
[pa_max i_a]=max(projected_a);%greater projection on edge a
[pb_max i_b]=max(projected_b);%greater projection on edge b
[pc_max i_c]=max(projected_c);%greater projection on edge c

end

