function [eADD_m] = compute_eADD_v2(estimatedPlanes, ...
    gtPoses,  tao, dataSetPath, NpointsDiagPpal)
%COMPUTE_EADD Computes e_ADD for point clouds objects. 

%   Detailed explanation goes here
Nep=size(estimatedPlanes,2);
Ngtp=size(gtPoses,1);
eADD_m=ones(Nep,Ngtp);

for i=1:Ngtp
    boxID=gtPoses(i,1);
    gtPose=assemblyTmatrix(gtPoses(i,2:end));
    for j=1:Nep
%         estimatedPlaneID=estimatedPlanesID(j,2);
        estimatedPlane=estimatedPlanes(j);
        eADD=comparePlanes(boxID, gtPose, estimatedPlane,dataSetPath,tao, NpointsDiagPpal);%boxID, gtPose, detectedPlane,dataSetPath,tao
        eADD_m(j,i)=eADD;
    end
end

end

