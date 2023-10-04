function [precision, recall, matchID] = computeMetricsByFrame_lateralPlanes(estimatedPose,...
    theta,tao, pps, pkflag)
%COMPUTEMETRICSBYFRAME Computes precision and recall in a single frame. The
%frame is described in the input estimatedPose. The computation is
%parametrized with the thresholds theta and tao
% Assumption: estimated pose is not empty
% 

if nargin<5
    pkflag=0;
end


% Nb=Nobjects*4;%number of gt planes in scene at frame
% computes relationship between estimatedPlaneID and gtPlaneID. Note that 
% estimatedPlaneID has two dimensions, gtPlaneID has two dimensions, then 
% matchID has four columns

% conversión de pps de 1D a 2D
pps=extendPlaneID(pps);

%COMPUTEMATCHID computes matches based on comparisons btwn eADD and theta
%   The output is in the format [planeID, boxID]. For boxID=0, there are
%   not matches. 
    planeIDs=estimatedPose.IDObjects;
    eADD_m=estimatedPose.eADD.(['tao' num2str(tao)]);
    matchID=compare_eADDvsTheta_lateralPlanes(eADD_m,theta,planeIDs,pps);


% compute boxes with multiple repetitions and number of repetitions
multipleDetected=myFindDuplicates_2D(matchID(:,3:4));%[boxID numberOfRepetitions]
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
    redundantRep=redundantRep+multipleDetected(i,3)-1;
end
% compute True Positive Redundant (TPR)
DP=size(matchID,1);%detected planes
zeroElements=find(matchID(:,3)==0);
TPR=DP-length(zeroElements);
% compute True Positive (TP)
TP=TPR-redundantRep;
% recall=TP/Nb;
FN=size(estimatedPose.FN,1);
recall=TP/(TP+FN);
% precision=TPR/DP;
if pkflag==1
    precision=TPR/DP;
else
    precision=TPR/(DP+estimatedPose.Nnap);%add number of non-acepted planes to denominator
end

end

