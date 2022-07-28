% clc
% close all
% clear all

% load twin planes
A=myPlanes.fr3.values(7);
B=myPlanes.fr2.values(6);
% convert to corner parameters and save the result in the correspondent
% fields of the object; use pass by reference
gcLength2corners(A);
gcLength2corners(B);

% compute IoU index
A_st=convertObjectToStruct(A);
B_st=convertObjectToStruct(B);
IoU=computeIOU(A_st,B_st)
