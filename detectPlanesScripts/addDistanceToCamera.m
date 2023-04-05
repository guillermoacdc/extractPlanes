function [localPlanes] = addDistanceToCamera(localPlanes,acceptedPlanes)
%ADDDISTANCETOCAMERA Set a property distanceToCamera for all objects in the
%IDs list. 
%   Detailed explanation goes here
N=size(acceptedPlanes,1);
frame=acceptedPlanes(1,1);
cameraPose=localPlanes.(['fr' num2str(frame)]).cameraPose(1:3,4);
for i=1:N
    localPlanes.(['fr' num2str(frame)]).values(acceptedPlanes(i,2)).setDistanceToCamera(cameraPose);    
end

end

