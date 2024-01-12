function [planeDescriptor_gt] = loadGTPlanes_v2(sessionID, frameID, planeType, fileName)
%LOADGTPLANES Loads descriptors of gt planes in the local point cloud p(k)
%   Detailed explanation goes here


% fileName='visiblePlanesByFrame.json';
visiblePlanesVector = loadVisiblePlanesByType(fileName,sessionID, frameID, planeType);
pps=unique(visiblePlanesVector(:,1));
Nb=length(pps);

planeDescriptor_gt=[];
for i=1:Nb
    boxID=pps(i);
    sidesVector=findSidesFromvpv(visiblePlanesVector,boxID);
    % load descriptors of planes that compose boxID
    planeDescriptor_temp = convertPK2PlaneObjects_v5(boxID,sessionID, ...
    sidesVector, frameID);
    planeDescriptor_gt=[planeDescriptor_gt, planeDescriptor_temp];
end

end

