function yaw = computeYawP2(globalPlanes,indexSet)
%COMPUTEYAWP1 Computes yaw in cases of a couple composed by a top and a
%perpdendicular 2 plane

ztop=globalPlanes(indexSet(1)).tform(1:3,3);
ntop=globalPlanes(indexSet(1)).tform(1:3,2);

xp2=globalPlanes(indexSet(2)).tform(1:3,1);
xp2p=projectSinglePointToPlaneModel(xp2,ntop',0);%resuls is a scalar

yaw=computeAngleBtwnVectors(ztop,xp2p);
if yaw>90
    yaw=180-yaw;
end

end

