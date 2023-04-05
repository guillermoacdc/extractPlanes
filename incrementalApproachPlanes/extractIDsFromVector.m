function [ids] = extractIDsFromVector(planesVector)
%EXTRACTIDSFROMVECTOR Summary of this function goes here
%   Detailed explanation goes here
N=size(planesVector,2);
ids=zeros(N,2);

for i=1:N
    ids(i,1)=planesVector(i).idFrame;
    ids(i,2)=planesVector(i).idPlane;
end


end

