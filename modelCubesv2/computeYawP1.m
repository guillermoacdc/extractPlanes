function yaw = computeYawP1(globalPlanes,indexSet)
%COMPUTEYAWP1 Computes yaw in cases of a couple composed by a top and a
%perpdendicular 1 plane
%computes angle btwn xtop and xside1_p

xtop=globalPlanes(indexSet(1)).tform(1:3,1);
ntop=globalPlanes(indexSet(1)).tform(1:3,2);

xp1=globalPlanes(indexSet(2)).tform(1:3,1);
xp1p=projectSinglePointToPlaneModel(xp1,ntop',0);%resuls is a scalar

yaw=computeAngleBtwnVectors(xtop,xp1p);

if yaw>90
    yaw=180-yaw;
end

end

