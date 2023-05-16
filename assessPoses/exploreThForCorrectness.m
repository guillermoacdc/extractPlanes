function [pc_gt, pc_scanned, correctness_v] = exploreThForCorrectness(theta_v,...
    plane_gt, plane_scanned, NpointsDiagTopSide, tao)
%EXPLORETHFORCORRECTNESS Computes the correctness for different
%combinations of threshold (theta) vales. 
Ntheta=size(theta_v,1);
correctness_v=myBoolean(zeros(Ntheta,1));

spatialSampling=sqrt(plane_gt.L1^2+plane_gt.L2^2)/NpointsDiagTopSide;

% create ground truth pc centered in the origin
pc_gt=createSingleBoxPC_topSide(plane_gt.L1,plane_gt.L2,plane_gt.H,spatialSampling);
% create scanned pc with max error thresholds
pc_scanned=myProjection_v3(pc_gt,plane_scanned.tform);
% compute eADD
[~, er]=computeSinglePoseError(plane_gt.tform,plane_scanned.tform);
eADD=computeSingle_eADD(pc_gt,pc_scanned, er, tao);
% compute correctness based on eADD
for i=1:Ntheta
    if eADD<theta_v(i)
        correctness_v(i)=true;
    end
end
% validation figures
end

