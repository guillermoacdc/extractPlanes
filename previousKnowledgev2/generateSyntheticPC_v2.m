function [pc, planeDescriptor] = generateSyntheticPC_v2(boxID,sessionID, ...
    sidesVector, frameHL2, NpointsDiagTopSide, gridStep, dataSetPath)
%GENERATESYNTHETICPC_v2 Generates a single synthetic point cloud for a single box 
% . Also returns the planeDescriptor object with descriptors of each
%plane
% groupTypeVector codes
% 1 top plane
% 2 front plane
% 3 right plane
% 4 back plane
% 5 left plane



% load descriptors of boxID
planeDescriptor = convertPK2PlaneObjects_v5(boxID,sessionID, ...
    sidesVector, frameHL2);
% create point cloud of each box ID on qbox
pc=createSyntheticPC_v2(planeDescriptor,NpointsDiagTopSide,boxID, gridStep, dataSetPath);

end

