function matchFlag=matchAssessmentPose_v2(eADD, theta,L1gt,L2gt)
%MATCHASSESSMENTPOSE Summary of this function goes here
%   Detailed explanation goes here

matchFlag=false;
% d=sqrt(L1gt^2+L2gt^2);
if eADD<theta
    matchFlag=true;
end

end

