function [centralPoint] = computeCentralPoint(p1,p2)
%COMPUTECENTRALPOINT Computes the central point between two 3D points p1,
%p2
% assumption: |p2|>=|p1|
% p2 and p1 are located in the positive zone of the coordinate system

centralPoint=p1+(p2-p1)/2;
end

