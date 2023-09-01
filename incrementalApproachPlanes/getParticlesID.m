function [id] = getParticlesID(particlesVector)
%GETPARTICLESID Summary of this function goes here
%   Detailed explanation goes here
N=size(particlesVector,2);
id=zeros(N,1);
for i=1:N
    id(i)=particlesVector(i).id;
end
end

