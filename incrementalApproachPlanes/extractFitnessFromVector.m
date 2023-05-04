function [ids] = extractFitnessFromVector(planesVector)
%EXTRACTIDSFROMVECTOR Summary of this function goes here
%   Detailed explanation goes here
N=size(planesVector,2);
ids=zeros(N,1);

for i=1:N
    ids(i,1)=planesVector(i).fitness;
%     ids(i,2)=planesVector(i).distanceToCamera;
end


end

