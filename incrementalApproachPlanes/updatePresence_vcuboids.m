function [globalPlanes, particlesVector] = updatePresence_vcuboids(globalPlanes,particlesVector,windowInit,...
    firstKeyFrame, th_vigency) 
%UPDATEPRESENCE_VCUBOIDS Summary of this function goes here
%   Detailed explanation goes here
% 
% group planes by type
% [globalPlanes.xzIndex, globalPlanes.xyIndex, globalPlanes.zyIndex]=extractTypes_vcuboids(globalPlanes);
% perform update in planes of same type
[globalPlanes_xz, particlesVector_xz] =updatePresence_v3(globalPlanes.values(globalPlanes.xzIndex),particlesVector.xz,windowInit,...
    firstKeyFrame, th_vigency); 

[globalPlanes_xy, particlesVector_xy] =updatePresence_v3(globalPlanes.values(globalPlanes.xyIndex),particlesVector.xy,windowInit,...
    firstKeyFrame, th_vigency); 

[globalPlanes_zy, particlesVector_zy] =updatePresence_v3(globalPlanes.values(globalPlanes.zyIndex),particlesVector.zy,windowInit,...
    firstKeyFrame, th_vigency); 

globalPlanes.values=[globalPlanes_xz, globalPlanes_xy,globalPlanes_zy];
[xzIndex, xyIndex, zyIndex]=extractTypes_vcuboids(globalPlanes.values);
globalPlanes.xzIndex=xzIndex;
globalPlanes.xyIndex=xyIndex;
globalPlanes.zyIndex=zyIndex;

particlesVector.xz=particlesVector_xz;
particlesVector.xy=particlesVector_xy;
particlesVector.zy=particlesVector_zy;
% join independent results or results by type
% 
end

