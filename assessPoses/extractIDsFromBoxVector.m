function IDs = extractIDsFromBoxVector(boxVector)
%EXTRACTIDSFROMBOXVECTOR Summary of this function goes here
%   Detailed explanation goes here

Nb=length(boxVector);
IDs=zeros(Nb,1);
for i=1:Nb
    IDs(i)=boxVector(i).id;
end
end

