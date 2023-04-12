function [DP, DPm, precision, recall] = computeMetricsByFrame(estimatedPose,theta,tao, pps)
%COMPUTEMETRICSBYFRAME Summary of this function goes here
%   Detailed explanation goes here
% Assumption: estimated pose is not empty
Nb=length(pps);
matchID=computeMatchID(estimatedPose,theta,tao,pps);%[estimatedPlaneID boxID]
DP=size(matchID,1);
zeroElements=find(matchID(:,3)==0);
DPm=DP-length(zeroElements);
recall=DPm/Nb;
precision=DPm/DP;
end

