function [pc] = createSyntheticPC_v2(planeDescriptor,NpointsDiagTopSide,boxID, gridStep, dataSetPath)
%CREATESYNTHETICPC_V2 Summary of this function goes here
%   Detailed explanation goes here
Nplanes=size(planeDescriptor,2);


% load gt lengths
lengths_array=getPreviousKnowledge(dataSetPath,boxID); % Id,Type,Heigth(cm),Width(cm),Depth(cm)
% H=lengths_array(2)*10;%mm
W=lengths_array(3)*10;%mm
D=lengths_array(4)*10;%mm

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
    pccell{i}=createPlanePCAtOrigin(pDescriptor,spatialSampling);
end
pc=mergePC_cell(pccell,gridStep);
end

