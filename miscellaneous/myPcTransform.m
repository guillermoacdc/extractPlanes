function [p_m] = myPcTransform(pcInput,tform)
%MYPROJECTION Projects  pcInput to p_m using the transformatio matrix tform

N=pcInput.Count;
for i=1:N
    proj=tform*[pcInput.Location(i,1) pcInput.Location(i,2) pcInput.Location(i,3) 1]';
    xyz(i,:)=proj(1:3)';
end
    p_m= pointCloud(xyz);%
end

