function [poses, L1e, L2e, Ninliers, fitness]=convertToArrays_v2(estimatedPoses_m)
%CONVERTTOARRAYS Summary of this function goes here
%   Detailed explanation goes here
N=size(estimatedPoses_m,2);
poses=zeros(N,16);
L1e=zeros(1,N);
L2e=zeros(1,N);
% dc=zeros(1,N);%requires T in qh, cause cameraPose is in qh
% angle=zeros(1,N);
fitness=zeros(1,N);
Ninliers=zeros(1,N);
% cameraPose=estimatedPoses_m.(['frame' num2str(estimatedPlanesID(1,1))]).cameraPose;
for i=1:N
    tform=estimatedPoses_m(i).tform;
    ttform=tform';%to comply with standard for transformations in our project
    poses(i,:)=ttform(1:end);%mm
    L1e(i)=estimatedPoses_m(i).L1*1000;%mm
    L2e(i)=estimatedPoses_m(i).L2*1000;%mm
    fitness(i)=estimatedPoses_m(i).fitness;
%     las siguientes propiedades deben ser calculadas con un método
%     diferente en el caso de planos cmpuestos
%     dc(i)=estimatedPoses_m(i).distanceToCamera;
%     angle(i)=estimatedPoses_m(i).angleBtwn_zc_unitNormal;
    Ninliers(i)=estimatedPoses_m(i).numberInliers;

end

end

