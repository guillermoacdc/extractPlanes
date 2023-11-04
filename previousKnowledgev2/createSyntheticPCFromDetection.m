function [pc] = createSyntheticPCFromDetection(planeDescriptor,...
    NpointsDiagTopSide, gridStep, W, D)
%CREATESYNTHETICPC_V2 Summary of this function goes here
%   Detailed explanation goes here
Nplanes=size(planeDescriptor,2);
% compute gt lengths l1, l2
if W>=D
    L1=D;
    L2=W;
else
    L1=W;
    L2=D;    
end
spatialSampling=sqrt(L1^2+L2^2)/NpointsDiagTopSide;
for i=1:Nplanes
    pDescriptor=planeDescriptor(i);
    pccell{i}=createPlanePCAtOriginOfqh(pDescriptor,spatialSampling);
end

%
pc=mergePC_cell(pccell,gridStep);
end

