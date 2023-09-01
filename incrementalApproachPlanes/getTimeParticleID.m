function [id] = getTimeParticleID(planeDescriptor)
%GETPARTICLESID Summary of this function goes here
%   Detailed explanation goes here
N=size(planeDescriptor,2);
id=zeros(N,1);
for i=1:N
    id(i)=planeDescriptor(i).timeParticleID;
end
end

