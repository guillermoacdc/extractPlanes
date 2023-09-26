function [detectedID, gtID, visiblePlane]= computeMatchBtwnPlanes(estimatedPlanes, ...
    gtPlanes,  tao, NpointsDiagPpal)

%COMPUTEMATCHBTNWPLANES Computes e_ADD for point clouds objects. 

%   Detailed explanation goes here
Nep=size(estimatedPlanes,2);
Ngtp=size(gtPlanes,2);%modified in objects version
gtID=[];
detectedID=[];
visiblePlane=[];
for i=1:Ngtp
    gtPlane=gtPlanes(i);
    visiblePlane=[gtPlane.idBox, gtPlane.idPlane];
    for j=1:Nep
        estimatedPlane=estimatedPlanes(j);
        eADD=comparePlanes_v2(gtPlane, estimatedPlane,tao, NpointsDiagPpal);%boxID, gtPlane, detectedPlane,dataSetPath,tao
        detectedID=j;
        if eADD==0
            gtID=i;
%             disp('debugg mark')
            return
        end
    end
end
