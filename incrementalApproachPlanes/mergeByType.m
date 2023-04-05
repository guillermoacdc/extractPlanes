function globalAcceptedPlanes = mergeByType(localPlanes,localAcceptedPlanes, globalAcceptedPlanes)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% extract types
[xzPlanes_g xyPlanes_g zyPlanes_g]=extractTypes(localPlanes, globalAcceptedPlanes);
[xzPlanes_l xyPlanes_l zyPlanes_l]=extractTypes(localPlanes, localAcceptedPlanes);


% merging for xzPlanes
globalAcceptedPlanes_xz=mergeAndExtractIDs(localPlanes, xzPlanes_l, xzPlanes_g);
globalAcceptedPlanes_xy=mergeAndExtractIDs(localPlanes, xyPlanes_l, xyPlanes_g);
globalAcceptedPlanes_zy=mergeAndExtractIDs(localPlanes, zyPlanes_l, zyPlanes_g);


globalAcceptedPlanes=[globalAcceptedPlanes_xz; globalAcceptedPlanes_xy; globalAcceptedPlanes_zy];

