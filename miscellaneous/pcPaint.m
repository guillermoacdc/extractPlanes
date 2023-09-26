function [ptCloud] = pcPaint(ptCloud,color)
%PCPAINT set the property color of a point cloud
%   The color must be a vector of three elements in range 0-255 (). 
% example: [255 255 51] for yellow
% see RGB triplet in https://la.mathworks.com/help/matlab/creating_plots/specify-plot-colors_es.html

pointscolor=uint8(zeros(ptCloud.Count,3));
pointscolor(:,1)=color(1);
pointscolor(:,2)=color(2);
pointscolor(:,3)=color(3);
ptCloud.Color=pointscolor;
end

