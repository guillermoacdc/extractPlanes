function [TPhl2, TPm, FPhl2, matchID]=convert_eDm2TP(eD_m, theta, myBoxes, gtBoxes)
%CONVERT_EDM2TP Summary of this function goes here
%   Detailed explanation goes here

FPhl2=[];
TPhl2=[];
TPm=[];
gtIDs=extractIDsFromBoxVector(gtBoxes);
estimatedIDs=extractIDsFromBoxVector(myBoxes);
matchID = computeRelationsBtwnEstimationsAndGT(eD_m,theta,estimatedIDs,...
    gtIDs);
Nmatch=size(matchID,1);
for i=1:Nmatch
    if matchID(i,2)==0 %FP
        FPhl2=[FPhl2;matchID(i,1)];
    else %TP
        TPhl2=[TPhl2; matchID(i,1)];
        TPm=[TPm; matchID(i,2)];
    end
end


end

