function [pc, planeDescriptor] = generateSyntheticPC(boxID,sessionID, ...
    numberOfSides, frameHL2, NpointsDiagTopSide, planeType, dataSetPath)
%GENERATESYNTHETICPC Generates a single synthetic point cloud with required
%boxes. Also returns the planeDescriptor object with descriptors of each
%plane

Nb=length(boxID);

%% generation of single boxes
% load descriptors of boxID
planeDescriptor = convertPK2PlaneObjects_v3(dataSetPath,sessionID,planeType, frameHL2, boxID);
% create point cloud of each box ID on qbox
pc_i=createSyntheticPC(planeDescriptor,NpointsDiagTopSide, numberOfSides);
%% projection of each box to their corresponding pose and merge
pc=projectPCtoGTPoses(pc_i,planeDescriptor);

end

