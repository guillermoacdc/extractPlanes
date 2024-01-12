% clc
% close all
% clear 

% x=[2 1; 0 0; 1 4; 1 1; 1 3; 1 4; 0 0; 0 0; 3 4; 3 1; 3 4 ];
x=[extractIDsFromVector(globalPlanesPrevious.values); extractIDsFromVector(globalPlanes.values)];
y=myFindDuplicates_2D(x)


A=extractIDsFromVector(globalPlanesPrevious.values);
B=extractIDsFromVector(globalPlanes.values);
C=mySetDiff_2D(A,B)