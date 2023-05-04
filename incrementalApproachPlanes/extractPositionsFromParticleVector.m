function [pos] = extractPositionsFromParticleVector(particlesVector)
%EXTRACTPOSITIONSFROMPARTICLEVECTOR Summary of this function goes here
%   Detailed explanation goes here
N=size(particlesVector,2);
pos=zeros(N,3);

for i=1:N
    pos(i,:)=particlesVector(i).getPosition;
end
end

