function [L1 L2 tform] = computeL1L2(pc, typeOfPlane, modelParameters, plotFlag)
%COMPUTEL1L2 This function computes the parameters L1, L2 of a point cloud
%that have been modeled as a plain. The plain can be parallel or 
% perpendicular to ground plane 

% Assumptions: the points in pc have been projected to a plane model
% described by modelParameters

if(typeOfPlane==0)%parallel to ground plane
    [L1 L2 tform]=computeL1L2Parallel(pc, modelParameters,plotFlag);
elseif (typeOfPlane==1 | typeOfPlane==2)%perpendicular planes
    [L1 L2 tform]=computeL1L2Perpendicular(pc, modelParameters,plotFlag);
else%non expected planes
    L1=0;
    L2=0;
    tform=0;
end

