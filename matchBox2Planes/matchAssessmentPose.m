function matchFlag=matchAssessmentPose(er, et, eADD, th_vector)
%MATCHASSESSMENTPOSE Summary of this function goes here
%   Detailed explanation goes here

matchFlag=false;
if (er<=th_vector(1) | (180-er)<=th_vector(1))  & eADD<=th_vector(3)
    matchFlag=true;
end

end

