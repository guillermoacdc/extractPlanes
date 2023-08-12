function [p_projected] = projectSinglePoint2Plane(p,A,B,C,D)
%PROJECTSINGLEPOINT2PLANE Projects a 3D Point to a plane model described by
%normal [A,B,C] and distance D
% assumptions: p is a column vector with size 3x1

% Computes distance btwn pont and plane, along normal of plane
d=[A B C]*p+D;
% Projects the point to the plane
p_projected=p-d*[A B C]';

end

