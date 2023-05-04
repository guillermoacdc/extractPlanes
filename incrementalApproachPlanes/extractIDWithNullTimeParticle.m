function [ID] = extractIDWithNullTimeParticle(vector)
%EXTRACTIDWITHNULLTIMEPARTICLE Summary of this function goes here
%   Detailed explanation goes here
ID=[];
N=size(vector,2);
k=1;
for i=1:N
    if isempty(vector(i).timeParticleID)
        ID(k)=i;
        k=k+1;
    end
end
end

