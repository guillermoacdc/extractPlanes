function [geometricCnorm] = extractgcFromID(planesVector, IDs)
%EXTRACTIDSFROMVECTOR Summary of this function goes here
%   Detailed explanation goes here
N=size(IDs,1);
geometricCnorm=zeros(N,1);

for i=1:N
    geometricCnorm(i,1)=norm(planesVector.(['fr' num2str(IDs(i,1))]).values(IDs(i,2)).geometricCenter);
    
end

end