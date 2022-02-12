function [L1 L2 tform normalType]= measurePlaneParameters(pc, modelParameters, groundNormal, myTolerance)
% This function measures three parameters of a point cloud pc: length L1,
% length L2 and type of normal. 
% A future version can return the transformation matrix of L1 and L2
% input: 
% 1. pc: segmented Point Cloud tha have been fitted by the model of a plane
% 2. modelParameters: parameters of the plane model,  plane normal [A B C] 
% plane distnace (D), and geometric center (x, y, z)
% 3. groundNormal: normal vector of the ground. As row vector
% 4. myTolerance: The treshold angle (in degrees) to classify a normal as 
% parallel or orthogonal to the ground's normal. Suggested value: 10

% output: descriptors of the segmented plane
% L1
% L2
% normal type codified in four values: 
% 0 for parallel planes to ground, (plane x-z)
% 1 for perpendicular planes inclined to x-y axis
% 2 for perpendicular planes inclined to z-y axis
% 3 for non expected planes
% Author: Guillermo Camacho
% Date 09/02/2022

%% project pc to its plane model
% project inliers into the fitted model
pc_projected=projectInPlane(pc,modelParameters);

%% classify the plane by its normal
myTol=myTolerance*pi/180;%convert to radians
% compute angle between normal of plane and normal of ground
A=modelParameters(1);
B=modelParameters(2);
C=modelParameters(3);
alpha=computeAngleBtwnVectors([A B C],groundNormal);


if( abs(cos(alpha*pi/180)) > cos (myTol))%parallel to ground plane
    normalType=0;

elseif (abs(cos(alpha*pi/180))< cos (pi/2-myTol) )%perpendicular to ground plane
   
    devx=std(pc_projected.Location(:,1));
    devz=std(pc_projected.Location(:,3));
    if (devx>=devz)%inclined to x-y axis
        normalType=1;
    else        %inclined to z-y axis
        normalType=2;
    end
    
else
    normalType=3;%non-expected plane
end


%% compute L1, L2
[L1 L2 tform]=computeL1L2(pc_projected,normalType, modelParameters);
end