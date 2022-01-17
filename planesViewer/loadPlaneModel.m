function [modelParameters,pc] = loadPlaneModel(planesPath,i)
%LOADPLANEMODEL Summary of this function goes here
%   Detailed explanation goes here
A=load([planesPath + "planeParameters.txt"]);
modelParameters_t=A(i,:);

pc = pcread([planesPath + "Plane" + num2str(i-1) + "A.ply"]);%in [mt]; indices begin at 0
%% rotate points around x axis
theta=-pi/2;
    A = [1 0 0 0; ...
        0 cos(theta) -sin(theta) 0;...
        0 sin(theta) cos(theta) 0;...
        0 0 0 1];
    tform = affine3d(A);
pc = pctransform(pc,tform);%alligned ptcloud
%% rotate model parameters
% rotate normal
modelParameters=A*[modelParameters_t(1:3) 1]';
distance=[];
modelParameters(4)=modelParameters_t(4);%distance parameter
%% paint the point cloud
pointscolor=uint8(zeros(pc.Count,3));
pointscolor(:,1)=255;
pointscolor(:,2)=255;
pointscolor(:,3)=51;
pc.Color=pointscolor;
end

