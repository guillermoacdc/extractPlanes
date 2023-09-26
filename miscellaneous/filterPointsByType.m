function [inlierMarkedIndex, outlierMarkedIndex, cosAlpha] = filterPointsByType(nonGroundPtCloud,th_angle)
%FILTERPOINTSBYTYPE Perfom a detection of top and lateral planes, then
%filter the point cloud based on the typeObject in the input
% inliersTopPlanes: indexes of points that belong to top planes
% inliersLateralPlanes: indexes of points that belong to lateral planes
% cosAlpha: abs(cos) of the angle btwn each normal point and the vector [0 0 1]

% compute cos of angle btwn point normal and [0 0 1]
cosAlpha = computeCosAlpha(nonGroundPtCloud,[0 0 1]);

inlierMarkedIndex=[];
outlierMarkedIndex=[];

% operates for perpendicular planes
for i=1:nonGroundPtCloud.Count
    if cosAlpha(i)>cos(th_angle*pi/180)
        inlierMarkedIndex=[inlierMarkedIndex i];%perpendicular planes index
    else
        outlierMarkedIndex=[outlierMarkedIndex i];%parallel to ground planes index
    end
end


end

