function eADD= compute_eADDTwins(localDescriptor,globalDescriptor, tao)
%COMPUTE_EADDTWINS Computes the eADD error function from descriptors of
%scanned planes. This version is designed to solve the computation of
%criterion 1 (c1) in categorizing twin planes. c1 is the case when two
%twins are not occluded and not merged.
%   Detailed explanation goes here

nearestDescriptor=computeNearestDescriptor(localDescriptor, globalDescriptor);
planeDescriptor.fr0.values(1)=nearestDescriptor;
NpointsDiagTopSide=50;
numberOfSides=1;
% create point cloud qplane
genericPC=createSyntheticPC(planeDescriptor,NpointsDiagTopSide, numberOfSides);
genericPC=genericPC{1};
% project to local pose
localPC=myProjection_v4(genericPC,localDescriptor.tform);
% project to global pose
globalPC=myProjection_v4(genericPC,globalDescriptor.tform);

[~,eR]=computeSinglePoseError(localDescriptor.tform, globalDescriptor.tform);
eADD=computeSingle_eADD(localPC,globalPC,eR,tao);

end

