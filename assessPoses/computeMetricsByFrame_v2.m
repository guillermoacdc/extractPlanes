function [precision, recall] = computeMetricsByFrame_v2(estimatedPose,theta,tao, pps)
%COMPUTEMETRICSBYFRAME Computes precision and recall in a single frame. The
%frame is described in the input estimatedPose. The computation is
%parametrized with the thresholds theta and tao
% Assumption: estimated pose is not empty
% 
Nb=length(pps);%number of boxes in the frame
% computes relationship between planeID and boxID. Note that planeID has
% two dimensions, then matchID has three columns
matchID=computeMatchID(estimatedPose,theta,tao,pps);%[estimatedPlaneID boxID]
% compute boxes with multiple repetitions and number of repetitions
multipleDetected=myFindDuplicates(matchID(:,3));%[boxID numberOfRepetitions]
% delete multiple detections when the boxID is zero

if ~isempty(multipleDetected)
    idx=find(multipleDetected(:,1)==0);
    if ~isempty(idx)
        multipleDetected(idx,:)=[];
    end
end

Nmd=size(multipleDetected,1);%number of multiple detected boxes
% compute redundant repetitions
redundantRep=0;
for i=1:Nmd
    redundantRep=redundantRep+multipleDetected(i,2)-1;
end
% compute True Positive Redundant (TPR)
DP=size(matchID,1);%detected planes
zeroElements=find(matchID(:,3)==0);
TPR=DP-length(zeroElements);
% compute True Positive (TP)
TP=TPR-redundantRep;
recall=TP/Nb;
precision=TPR/DP;
end

