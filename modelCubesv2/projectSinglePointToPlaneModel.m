function [p_out] = projectSinglePointToPlaneModel(p,n,D)
%PROJECTSINGLEPOINTTOPLANEMODEL Projects a point p into a plane model
%described by normal n and distance D
% Assumption
% n is a row vector
% p is a column vector
% D is an scalar
% compute distance btwn point and plane along n
d=dot(n,p)+D;
% translate p by a distance d along n
p_out=p-d*n';
end

