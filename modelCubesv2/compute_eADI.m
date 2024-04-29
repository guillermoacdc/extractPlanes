function [eADI, dist]= compute_eADI(pc_ref,pc_estimated)
%COMPUTE_EADI computes the error eADI btwn two point clouds
%   Detailed explanation goes here
N=pc_ref.Count;
dist=zeros(N,1);
for i=1:N
    pointi=pc_ref.Location(i,:);
    dist(i)=computeMinDistance(pointi,pc_estimated);
end
eADI=mean(dist);
end

function minDistance=computeMinDistance(pointi, pc)
N=pc.Count;
minDistance=10000;
for i=1:N
    d=norm(pointi-pc.Location(i,:));
    if d<minDistance
        minDistance=d;
    end
end

end