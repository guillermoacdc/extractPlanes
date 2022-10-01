function [modelPlane xyzPoints ptCloud] = myFitPlane(markers, maxDistance)
%MYFITPLANE Summary of this function goes here
%   Detailed explanation goes here
% Dimensions
% markers 3, number of markers
% tolerance 1x1

% create a point cloud from leds at a single frame
xyzPoints=zeros(4,3);%specified as an M-by-3 list of points
xyzPoints(1,:)=markers(:,1)';
xyzPoints(2,:)=markers(:,2)';
xyzPoints(3,:)=markers(:,4)';
xyzPoints(4,:)=markers(:,5)';
ptCloud = pointCloud(xyzPoints);
% fit a plane model from the pointcloud. Use a maxDistance of 5 mm between
% inliers and plane. Compute the plane model until obtain a plane with
% normal in the direction of gravity vector

alpha=150;%angle between normal vector of plane v and gravity
while(alpha>=150)%loops until find a normal in the same orientation that gravity vector
    modelPlane = pcfitplane(ptCloud,maxDistance);
    alpha=computeAngleBtwnVectors([0 0 -1],modelPlane.Parameters(1:3));%angle between normal of the plane and gravity vector
end


xyzPoints=zeros(5,3);%specified as an M-by-3 list of points
xyzPoints(1,:)=markers(:,1)';
xyzPoints(2,:)=markers(:,2)';
xyzPoints(3,:)=markers(:,3)';
xyzPoints(4,:)=markers(:,4)';
xyzPoints(5,:)=markers(:,5)';
ptCloud = pointCloud(xyzPoints);

end

