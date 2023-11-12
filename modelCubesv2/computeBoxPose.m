function boxPose=computeBoxPose(globalPlanes,setIndex,sideVector)
%COMPUTEBOXPOSE Computes the pose of a box in function of pose of its
%components: plane segments

Np=length(setIndex);%length of real plane segments
if Np>2
    yawp1=computeYawCouples(globalPlanes,setIndex(1:2), sideVector(1:2));
    yawp2=computeYawCouples(globalPlanes,[setIndex(1), setIndex(3)], [sideVector(1), sideVector(3)]);
    yaw=mean([yawp1, yawp2])/2;
else
    yawp=computeYawCouples(globalPlanes,[setIndex(1), setIndex(2)], sideVector);
    yaw=yawp/2;
end
boxPose=globalPlanes(setIndex(1)).tform;
boxPose(1:3,1:3)=roty(yaw)*globalPlanes(setIndex(1)).tform(1:3,1:3);
end

