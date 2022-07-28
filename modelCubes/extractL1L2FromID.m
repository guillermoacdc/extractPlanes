function [Lengths] = extractL1L2FromID(planesVector, IDs)
%EXTRACTIDSFROMVECTOR Summary of this function goes here
%   Detailed explanation goes here
N=size(IDs,1);
Lengths=zeros(N,2);

for i=1:N
    Lengths(i,1)=planesVector.(['fr' num2str(IDs(i,1))]).values(IDs(i,2)).L1;
    Lengths(i,2)=planesVector.(['fr' num2str(IDs(i,1))]).values(IDs(i,2)).L2;
end


end