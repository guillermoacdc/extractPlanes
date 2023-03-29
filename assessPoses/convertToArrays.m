function [poses, L1e, L2e, dc, Ninliers]=convertToArrays(estimatedPoses_m,estimatedPlanesID)
%CONVERTTOARRAYS Summary of this function goes here
%   Detailed explanation goes here
N=size(estimatedPlanesID,1);
poses=zeros(N,16);
L1e=zeros(1,N);
L2e=zeros(1,N);
dc=zeros(1,N);%requires T in qh, cause cameraPose is in qh
Ninliers=zeros(1,N);
% cameraPose=estimatedPoses_m.(['frame' num2str(estimatedPlanesID(1,1))]).cameraPose;
for i=1:N
    frameID=estimatedPlanesID(i,1);
    planeID=estimatedPlanesID(i,2);
    tform=estimatedPoses_m.(['fr' num2str(frameID)]).values(planeID).tform;
%     tform(1:3,4)=tform(1:3,4)*1000;
    ttform=tform';%to comply with standard for transformations in our project
    poses(i,:)=ttform(1:end);%mm
    L1e(i)=estimatedPoses_m.(['fr' num2str(frameID)]).values(planeID).L1*1000;%mm
    L2e(i)=estimatedPoses_m.(['fr' num2str(frameID)]).values(planeID).L2*1000;%mm

%     compute Ninliers in construction. I dont want to load a point cloud
%     too many times. 

end

end

