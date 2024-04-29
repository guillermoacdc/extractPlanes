function pc = createSyntheticPC_vss(planeDescriptor,spatialSampling, gridStep)
%CREATESYNTHETICPC_V2 creates a point cloud from a set of plane segments
%objects arranged in planeDescriptor vector
%   Detailed explanation goes here
Nplanes=size(planeDescriptor,2);

% spatialSampling=sqrt(planeDescriptor(1).L1^2+planeDescriptor(1).L2^2)/NpointsDiagTopSide;
for i=1:Nplanes
    pDescriptor=planeDescriptor(i);
    pccell{i}=createPlanePCAtOrigin_v2(pDescriptor,spatialSampling);
end
pc=mergePC_cell(pccell,gridStep);
end

