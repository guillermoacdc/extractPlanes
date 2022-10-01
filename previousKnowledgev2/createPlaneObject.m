function [planeDescriptor] = createPlaneObject(pose,mylength)
%CREATEPLANEOBJECT Creates a plane object for ground truth data
%   Detailed explanation goes here


tform_gt=assemblyTmatrix(pose(2:13));
n=tform_gt(1:3,4);
modelParameters=[0 0 1 n(3) n(1) n(2) n(3)];
%     create the plane object
planeDescriptor=plane(0, 0, 0, modelParameters,...
        'noPath', 0);%scene,frame,pID,pnormal,Nmbinliers
planeDescriptor.tform=tform_gt;
planeDescriptor.type=0;
planeDescriptor.planeTilt=1;%xz inclination
planeDescriptor.L1=mylength(1);%mm
planeDescriptor.L2=mylength(2);%mm
planeDescriptor.L2toY=1;%This means that all top planes are builded with L2 along y axis


end

