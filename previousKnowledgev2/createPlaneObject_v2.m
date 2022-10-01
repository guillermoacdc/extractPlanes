function [planeDescriptor] = createPlaneObject_v2(pose,boxLength,planeType)
%CREATEPLANEOBJECT Creates a plane object for ground truth data
%   Detailed explanation goes here


tform_top=assemblyTmatrix(pose(2:13));
angle=computeAngleBtwnVectors([1 0 0],tform_top(1:3,1));
if tform_top(1,2)<0
    angle=-angle;
end
[tform_gt,modelParameters] = computePoseFromGTBox(tform_top,boxLength,planeType,angle);

planeDescriptor=plane(0, 0, 0, modelParameters,...
        'noPath', 0);% scene,frame,pID,modelParameters,pathInliers,Nmbinliers. the scene and planeID parameters are updated outside this function
planeDescriptor.tform=tform_gt;
planeDescriptor.type=planeType;
planeDescriptor.planeTilt=[];%
planeDescriptor.L1=boxLength(1);%mm
planeDescriptor.L2=boxLength(2);%mm
planeDescriptor.L2toY=[];%


end

