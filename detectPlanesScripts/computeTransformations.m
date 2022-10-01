function [p_T_ref ref_T_p ] = computeTransformations(alpha, planeDescriptor)
%COMPUTETRANSFORMATIONS compute transformations between the frameworks
%q_ref and q_p; where p means plane
%   Detailed explanation goes here


% compute p_T_ref; useful to measure the length in 2D
p_T_ref=eye(4);
p_T_ref(1:3,1:3)=roty(alpha);%angle in degrees
p_T_ref(1:3,4)=planeDescriptor.geometricCenter';%translation component of the transformation

% compute ref_T_p; useful to record plane pose and verification figures
ref_T_p=eye(4);
ref_T_p(1:3,1:3)=roty(-alpha);%angle in degrees
ref_T_p(1:3,4)=planeDescriptor.geometricCenter';%translation component of the transformation


end

