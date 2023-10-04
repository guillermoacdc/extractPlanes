function [TPhl2, TPm, FPhl2]=converteADD2TP_FP(estimations_m,...
    gtPlanes, eADD_m, theta)
%CONVERTEADD2TP_FP converts eADD matrix to TPs and FPs indexes
%   Detailed explanation goes here
FPhl2=[];
TPhl2=[];
TPm=[];
planeIDs=extractIDsFromVector(estimations_m);
matchID=computeR_Estimated_GT_ID(eADD_m,theta,planeIDs,gtPlanes);
Nmatch=size(matchID,1);
for i=1:Nmatch
    if matchID(i,3)==0 %FP
        FPhl2=[FPhl2;matchID(i,1:2)];
    else %TP
        TPhl2=[TPhl2; matchID(i,1:2)];
        TPm=[TPm; matchID(i,3:4)];
    end
end

% TPhl2=matchID(:,1:2);
% TPm=matchID(:,3:4);
% FPhl2=mySetDiff_2D(planeIDs, TPhl2);
end

