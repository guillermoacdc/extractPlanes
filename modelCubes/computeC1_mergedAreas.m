function [c1] = computeC1_mergedAreas(currentPlane,joinedPlane,th_IOU)
%COMPUTEC1_MERGEDAREAS Summary of this function goes here
%   Detailed explanation goes here

%% compute IoU between currentPlane and joinedPlane

% convert to corner parameters and save the result in the correspondent
% fields of the object; use pass by reference
gcLength2corners(currentPlane);
gcLength2corners(joinedPlane);

% compute IoU index
A_st=convertObjectToStruct(currentPlane);
B_st=convertObjectToStruct(joinedPlane);
IoU=computeIOU(A_st,B_st);

%% compare IoU versus treshold
if IoU>0.3 & IoU<0.7
    c1=true;
else 
    c1=false;
end

end

