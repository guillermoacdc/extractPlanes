function [modelParameters, pc] = loadPlaneParameters(planesPath,frame,i)
%LOADPLANEMODEL Summary of this function goes here
%   Detailed explanation goes here
% OUTPUTS
% modelParameters is a vector of parameters of the plane : 
% normal( A, B, C) distance (D), geometric center (x, y, z) 
% pc is a pointcloud with the inliers that fit the plane model

% planesPath=[planesPath + "frame (" + num2str(frame) + ")/" ];
A=load([planesPath + "planeParameters.txt"]);
modelParameters=A(i,:);
modelParameters(4)=-modelParameters(4);%?



pc = pcread([planesPath + "Plane" + num2str(i-1) + "A.ply"]);%in [mt]; indices begin at 0

%% paint the point cloud
% pointscolor=uint8(zeros(pc.Count,3));
% pointscolor(:,1)=255;
% pointscolor(:,2)=255;
% pointscolor(:,3)=51;%51
% pc.Color=pointscolor;
end

