function [L1 L2 tform normalType]= measurePlaneParametersv2(pc, modelParameters, groundNormal, normalType, plotFlag)
% This function measures three parameters of a point cloud pc: length L1,
% length L2 and type of normal. 
% A future version can return the transformation matrix of L1 and L2
% input: 
% 1. pc: segmented Point Cloud tha have been fitted by the model of a plane
% 2. modelParameters: parameters of the plane model,  plane normal [A B C] 
% plane distnace (D), and geometric center (x, y, z)
% 3. normalType: (0, 1, 2) for (parallel, perpendicular, nonexpected)
% 4. myTolerance: The treshold angle (in degrees) to classify a normal as 
% parallel or orthogonal to the ground's normal. Suggested value: 10

% output: descriptors of the segmented plane
% L1 in meters (units of the sensor HL2)
% L2 in meters
% normal type codified in four values: 
% 0 for parallel planes to ground, (plane x-z)
% 1 for perpendicular planes inclined to x-y axis
% 2 for perpendicular planes inclined to z-y axis
% 3 for non expected planes
% Author: Guillermo Camacho
% Date 09/02/2022


if nargin<5
    plotFlag=1;%enable plots
end

%% project pc to its plane model
% project inliers into the fitted model
pc_projected=projectInPlane(pc,modelParameters);




%% compute L1, L2
[L1 L2 tform]=computeL1L2(pc_projected,normalType, modelParameters, plotFlag);
end