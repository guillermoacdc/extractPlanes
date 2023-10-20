function [planeDescriptor_gt] = loadGTPlanes(sessionID, frameID)
%LOADGTPLANES Loads descriptors of gt planes
%   Detailed explanation goes here
% dataSetPath=computeMainPaths(sessionID);
dataSetPath = computeReadPaths(sessionID);
pps=getPPS(dataSetPath, sessionID, frameID);
Nb=length(pps);
sidesVector=1:5;
planeDescriptor_gt=[];
for i=1:Nb
    boxID=pps(i);
    % load descriptors of planes that compose boxID
    planeDescriptor_temp = convertPK2PlaneObjects_v5(boxID,sessionID, ...
    sidesVector, frameID);
    planeDescriptor_gt=[planeDescriptor_gt, planeDescriptor_temp];
end

end

