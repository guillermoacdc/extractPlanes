function [localPlanes] = addDistanceToCamera(localPlanes,acceptedPlanes)
%ADDDISTANCETOCAMERA Set the properties distanceToCamera and angleBtwn_zc_unitNormal 
% for all objects in the IDs list. 
%   Detailed explanation goes here
N=size(acceptedPlanes,1);
frame=acceptedPlanes(1,1);
cameraPose=localPlanes.(['fr' num2str(frame)]).cameraPose(1:3,4);
zcVector=localPlanes.(['fr' num2str(frame)]).cameraPose(1:3,3);
for i=1:N
    localPlanes.(['fr' num2str(frame)]).values(acceptedPlanes(i,2)).setDistanceToCamera(cameraPose);    
    localPlanes.(['fr' num2str(frame)]).values(acceptedPlanes(i,2)).setAngleBtwn_zc_unitNormal(zcVector);
end

end

