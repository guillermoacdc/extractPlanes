function [pc_out] = applyTransformation(pc, T)
%APPLYTRANSFORMATION Rotates a point cloud using a matrix T with size 4x4
%   Detailed explanation goes here



% extract translation vector and apply the translation
% D=repmat(T(1:3,4)',size(pc.Location,1),1);
% pc_out1 = pctransform(pc,-D);%ptcloud centered in origin

% extract rotation matrix and rotate the point cloud
t=eye(4);
t(1:3,1:3)=T(1:3,1:3);
tform = affine3d(t);
pc_out= pctransform(pc,tform);%ptcloud alligned to axis
end


