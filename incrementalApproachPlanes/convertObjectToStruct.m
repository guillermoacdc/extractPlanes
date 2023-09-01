function [refPlaneDescriptor_str] = convertObjectToStruct(refPlaneDescriptor, boxID)
%CONVERTOBJECTTOSTRUCT Summary of this function goes here
%   Detailed explanation goes here
refPlaneDescriptor_str.idScene=refPlaneDescriptor.idScene;
refPlaneDescriptor_str.idFrame=refPlaneDescriptor.idFrame;
refPlaneDescriptor_str.idPlane=refPlaneDescriptor.idPlane;
refPlaneDescriptor_str.boxID=boxID;

refPlaneDescriptor_str.tform=refPlaneDescriptor.tform;
refPlaneDescriptor_str.L1=refPlaneDescriptor.L1;
refPlaneDescriptor_str.L2=refPlaneDescriptor.L2;
refPlaneDescriptor_str.numberInliers=refPlaneDescriptor.numberInliers;
refPlaneDescriptor_str.D=refPlaneDescriptor.D;

refPlaneDescriptor_str.distanceToCamera=refPlaneDescriptor.distanceToCamera;
refPlaneDescriptor_str.angleBtwn_zc_unitNormal=refPlaneDescriptor.angleBtwn_zc_unitNormal;

end

