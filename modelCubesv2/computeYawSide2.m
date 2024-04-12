function yaw = computeYawSide2(globalPlanes, topside, side2Index)
%COMPUTEYAWP1 Computes yaw in cases of a couple composed by a top and a
%perpdendicular 2 plane

ztop=globalPlanes(topside).tform(1:3,3);
ntop=globalPlanes(topside).tform(1:3,2);

xside2=globalPlanes(side2Index).tform(1:3,1);
xside2p=projectSinglePointToPlaneModel(xside2,ntop',0);%resuls is a scalar

yaw=computeAngleBtwnVectors(ztop,-xside2p);
if yaw>90
    yaw=180-yaw;
end

end

