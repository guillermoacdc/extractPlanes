function yaw=computeYaw(globalPlanes,setIndex, sideTriad)
%COMPUTEYAW Computes yaw angle btwn axis ztop and zp1, xp2
% first version for p1 and p2 planes
yaw=0;


Np=length(setIndex);%length of real plane segments
if Np>2
    yawp1=computeYawCouples(globalPlanes,setIndex(1:2), sideTriad(1:2));
    yawp2=computeYawCouples(globalPlanes,[setIndex(1), setIndex(3)], [sideTriad(1), sideTriad(3)]);
    yaw=mean([yawp1, yawp2])/2;
else
    yawp=computeYawCouples(globalPlanes,[setIndex(1), setIndex(2)], sideTriad);
    yaw=yawp/2;
end

end

