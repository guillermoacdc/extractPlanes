function c1 = computeC1_gcBtwnPlanes(currentPlane,joinedPlane,th_gc)
%COMPUTEC1_GCBTWNPLANES Summary of this function goes here
%   Detailed explanation goes here

d=norm(currentPlane.geometricCenter-joinedPlane.geometricCenter);

if d<th_gc
    c1=true;
else
    c1=false;
end

end

