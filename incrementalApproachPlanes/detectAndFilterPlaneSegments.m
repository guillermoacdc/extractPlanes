function [localPlanes,Nnap] = detectAndFilterPlaneSegments(sessionID,frameID, planeType, planeFilteringParameters, compensateFactor)
%DETECTANDFILTERPLANESEGMENTS Loads raw plane and perform filtering on the
%loaded plane, returns a single type of planes. Returns a vector of plane objects
%   Detailed explanation goes here
% [dataSetPath,~,PCpath] = computeMainPaths(sessionID);
[dataSetPath,PCpath] = computeReadPaths(sessionID);
PKFlag=1;
%load raw planes and filter
planeSegmentDescriptor=loadExtractedPlanes(dataSetPath,sessionID,frameID,...
        PCpath, planeFilteringParameters,  PKFlag, compensateFactor);%returns a struct with a property frx - h world
% compute number of non accepted planes
Nnap=size(planeSegmentDescriptor.(['fr' num2str(frameID)]).values,2)-size(planeSegmentDescriptor.(['fr' num2str(frameID)]).acceptedPlanes,1);
% extract target identifiers based on type of plane
if planeType==0
    % For top planes use
%     syntheticPlaneType=0;
    estimatedPlaneType=0;
else
    % For perpendicular planes use
%     syntheticPlaneType=3;
    estimatedPlaneType=3;
end
planeSegmentTargetID=extractTargetIDs(planeSegmentDescriptor,frameID,estimatedPlaneType);
% convert struct to vector localPlanes
localPlanes=loadPlanesFromIDs_d(planeSegmentDescriptor,planeSegmentTargetID);%vector in h world    
end

