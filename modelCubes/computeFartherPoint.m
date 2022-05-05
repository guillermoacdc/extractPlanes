function [pa_max pb_max] = computeFartherPoint(p0,pc, na, nb)
%COMPUTEFARTHERPOINT Summary of this function goes here
%   Detailed explanation goes here
% size(n)=3x1
% size(p0)=3x

for i=1:pc.Count
    projected_a(i)=((pc.Location(i,:)-p0') *na);
    projected_b(i)=((pc.Location(i,:)-p0') *nb);
end
pa_max=max(projected_a);%greater projection on edge a
pb_max=max(projected_b);%greater projection on edge b


end

