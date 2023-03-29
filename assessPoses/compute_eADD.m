function [eADD_m] = compute_eADD(estimatedPlanes, estimatedPlanesID,...
    gtPoses, frameID, tao, dataSetPath)
%COMPUTE_EADD Computes e_ADD for point clouds objects. 

%   Detailed explanation goes here
Nep=size(estimatedPlanesID,1);
Ngtp=size(gtPoses,1);
eADD_m=ones(Nep,Ngtp);

for i=1:Ngtp
    boxID=gtPoses(i,1);
    gtPose=assemblyTmatrix(gtPoses(i,2:end));
    for j=1:Nep
        estimatedPlaneID=estimatedPlanesID(j,2);
        estimatedPlane=estimatedPlanes.(['fr' num2str(frameID)]).values(estimatedPlaneID);
        eADD=comparePlanes(boxID, gtPose, estimatedPlane,dataSetPath,tao);%boxID, gtPose, detectedPlane,dataSetPath,tao
        eADD_m(j,i)=eADD;
    end
end

end

