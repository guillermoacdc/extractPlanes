function [ids] = extractIDsFromVector_v2(planesVector)
%EXTRACTIDSFROMVECTOR Summary of this function goes here
%   Detailed explanation goes here
% _v2: manages composed planes
N=size(planesVector,2);
ids=zeros(N,2);

k=1;
for i=1:N
    Ncomp=size(planesVector(i).idFrame,2);
    if Ncomp==1
        ids(k,1)=planesVector(i).idFrame;
        ids(k,2)=planesVector(i).idPlane;
    else
        for j=1:Ncomp
            ids(k,1)=planesVector(i).idFrame(j);
            ids(k,2)=planesVector(i).idPlane(j);
            k=k+1;
        end
    end
    k=k+1;
end


end

