function [eADD_m] = compute_eADD_v3(estimatedPlanes, ...
    gtPlanes,  tao, NpointsDiagPpal)
%COMPUTE_EADD Computes e_ADD for point clouds objects. 
% compute_eADD_v3(estimatedPlanes_m.values,gtVisiblePlanesByFrame, tao, NpointsDiagPpal)
%   Detailed explanation goes here
Nep=length(estimatedPlanes);
Ngtp=size(gtPlanes,2);%modified in objects version
eADD_m=ones(Nep,Ngtp);

for i=1:Ngtp
    gtPlane=gtPlanes(i);
    for j=1:Nep
%         estimatedPlaneID=estimatedPlanesID(j,2);
        estimatedPlane=estimatedPlanes(j);
        eADD=comparePlanes_v2(gtPlane, estimatedPlane,tao, NpointsDiagPpal);%boxID, gtPlane, detectedPlane,dataSetPath,tao
        eADD_m(j,i)=eADD;
    end
end

end

