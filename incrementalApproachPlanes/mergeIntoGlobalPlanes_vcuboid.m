function [globalPlanes, bufferComposedPlanes]=mergeIntoGlobalPlanes_vcuboid(localPlanes,...
            globalPlanesPrevious,tao_merg,theta_merg, lengthBoundsTop,...
            lengthBoundsP,bufferComposedPlanes, planeFilteringParameters, planeModelParameters, gridStep, compensateFactor)
%MERGEINTOGLOBALPLANES_VCUBOID performs a merge btwn planes with the same
%type
%   Detailed explanation goes here
% [xzp_gpp, xyp_gpp, zyp_gpp]=extractTypes_vcuboids(globalPlanesPrevious);
% [localPlanes.xzIndex, localPlanes.xyIndex, localPlanes.zyIndex]=extractTypes_vcuboids(localPlanes.values);

[globalPlanes_xz, bufferComposedPlanes_xz]=mergeIntoGlobalPlanes_v3(localPlanes.values(localPlanes.xzIndex),...
            globalPlanesPrevious(xzp_gpp),tao_merg,theta_merg, lengthBoundsTop,...
            lengthBoundsP,bufferComposedPlanes.xz, planeFilteringParameters, planeModelParameters, gridStep, compensateFactor);

[globalPlanes_xy, bufferComposedPlanes_xy]=mergeIntoGlobalPlanes_v3(localPlanes.values(localPlanes.xyIndex),...
            globalPlanesPrevious(xyp_gpp),tao_merg,theta_merg, lengthBoundsTop,...
            lengthBoundsP,bufferComposedPlanes.xy, planeFilteringParameters, planeModelParameters, gridStep, compensateFactor);

[globalPlanes_zy, bufferComposedPlanes_zy]=mergeIntoGlobalPlanes_v3(localPlanes.values(localPlanes.zyIndex),...
            globalPlanesPrevious(zyp_gpp),tao_merg,theta_merg, lengthBoundsTop,...
            lengthBoundsP,bufferComposedPlanes.zy, planeFilteringParameters, planeModelParameters, gridStep, compensateFactor);

globalPlanes.values=[globalPlanes_xz, globalPlanes_xy,globalPlanes_zy];
% find duplicateID in composed planes and update
bufferComposedPlanes.xz=bufferComposedPlanes_xz;
bufferComposedPlanes.xy=bufferComposedPlanes_xy;
bufferComposedPlanes.zy=bufferComposedPlanes_zy;

end

