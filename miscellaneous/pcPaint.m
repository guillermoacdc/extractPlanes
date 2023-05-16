function [ptCloud] = pcPaint(ptCloud,color)
%PCPAINT set the property color of a point cloud
%   Detailed explanation goes here

pointscolor=uint8(zeros(ptCloud.Count,3));
pointscolor(:,1)=color(1);
pointscolor(:,2)=color(2);
pointscolor(:,3)=color(3);
ptCloud.Color=pointscolor;
end

