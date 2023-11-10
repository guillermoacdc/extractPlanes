function yaw= computeYawCouples(globalPlanes,indexSet, side)
%COMPUTEYAWCOUPLES Computes yaw between two plane segments: (1) top plane,
%(2) perpendicular plane



if side(2)==1 | side(2)==3
    yaw=computeYawP1(globalPlanes,indexSet);
else
    yaw=computeYawP2(globalPlanes,indexSet);
end

