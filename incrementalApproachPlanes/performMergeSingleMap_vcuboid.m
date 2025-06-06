function [globalPlanes, bufferComposedPlanes] = performMergeSingleMap_vcuboid(globalPlanes,...
    tao_merg, theta_merg, ...
    th_coplanarDistance, planeFilteringParameters, planeModelParameters, ...
    lengthBoundsTop, gridStep, lengthBoundsP, compensateFactor, bufferComposedPlanes)
%PERFORMMERGESINGLEMAP_VCUBOID Summary of this function goes here
%   Detailed explanation goes here
% 
% 
% 
[globalPlanes_xz, bufferComposedPlanes_xz] = performMergeSingleMap(globalPlanes.values(globalPlanes.xzIndex),...
            tao_merg, theta_merg, ...
            th_coplanarDistance, planeFilteringParameters, planeModelParameters, ...
            lengthBoundsTop, gridStep, lengthBoundsP, compensateFactor, bufferComposedPlanes.xz);

[globalPlanes_xy, bufferComposedPlanes_xy] = performMergeSingleMap( globalPlanes.values(globalPlanes.xyIndex),...
            tao_merg, theta_merg, ...
            th_coplanarDistance, planeFilteringParameters, planeModelParameters, ...
            lengthBoundsTop, gridStep, lengthBoundsP, compensateFactor, bufferComposedPlanes.xy);

[globalPlanes_zy, bufferComposedPlanes_zy] = performMergeSingleMap(globalPlanes.values(globalPlanes.zyIndex),...
            tao_merg, theta_merg, ...
            th_coplanarDistance, planeFilteringParameters, planeModelParameters, ...
            lengthBoundsTop, gridStep, lengthBoundsP, compensateFactor, bufferComposedPlanes.zy);

bufferComposedPlanes.xz=bufferComposedPlanes_xz;
bufferComposedPlanes.xy=bufferComposedPlanes_xy;
bufferComposedPlanes.zy=bufferComposedPlanes_zy;

globalPlanes.values=[globalPlanes_xz, globalPlanes_xy,globalPlanes_zy];
[xzIndex, xyIndex, zyIndex]=extractTypes_vcuboids(globalPlanes.values);
globalPlanes.xzIndex=xzIndex;
globalPlanes.xyIndex=xyIndex;
globalPlanes.zyIndex=zyIndex;

end

