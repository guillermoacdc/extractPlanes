function [index] = myRangeSearch(exemplarSet,refSearch,th_angle)
%MYRANGESEARCH Summary of this function goes here
%   Detailed explanation goes here
index=[];
% compute angle alpha btwn refSearch and each one of the exemplar Sets
for i=1:length(exemplarSet)
    alpha(i)=abs(computeAngleBtwnVectors(exemplarSet(i,:),refSearch));
end
% select index where alpha is btwn the range set by th_angle
k=1;
for i=1:length(alpha)
    if alpha(i)<=th_angle
        index(k)=i;
        k=k+1;
    end
end


end

