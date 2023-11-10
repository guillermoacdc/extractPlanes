function [ids] = extractIDsFromVector(planesVector)
%EXTRACTIDSFROMVECTOR Summary of this function goes here
%   Detailed explanation goes here
% N=size(planesVector,2);
N=length(planesVector);
ids=zeros(N,2);

for i=1:N
    if ~isstruct(planesVector(i).idFrame)
        ids(i,1)=planesVector(i).idFrame;
    else
        ids(i,1)=planesVector(i).idFrame.mwdata;
    end
    ids(i,2)=planesVector(i).idPlane;    
end


end

