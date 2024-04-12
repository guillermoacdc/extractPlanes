function yaw = computeYawSide1(globalPlanes, topside, side1Index)
%COMPUTEYAWP1 Computes yaw in cases of a couple composed by a top and a
%perpdendicular 2 plane

xtop=globalPlanes(topside).tform(1:3,1);
ntop=globalPlanes(topside).tform(1:3,2);

xside1=globalPlanes(side1Index).tform(1:3,1);
xside1p=projectSinglePointToPlaneModel(xside1,ntop',0);%resuls is a scalar

yaw=computeAngleBtwnVectors(xtop,xside1p);
if yaw>90
    yaw=180-yaw;
end

end

