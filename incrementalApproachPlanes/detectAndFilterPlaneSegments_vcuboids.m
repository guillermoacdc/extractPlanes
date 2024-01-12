function [localPlanes,Nnap] = detectAndFilterPlaneSegments_vcuboids(sessionID,...
    frameID, planeFilteringParameters, compensateFactor, th_distance_depthCamera)
%DETECTANDFILTERPLANESEGMENTS Loads raw plane and perform filtering on the
%loaded plane, returns a single type of planes. Returns a vector of plane objects
%   Detailed explanation goes here
[dataSetPath,PCpath] = computeReadPaths(sessionID);
PKFlag=1;
%load raw planes and filter
[planeSegmentDescriptor, cameraPose]=loadExtractedPlanes(dataSetPath,sessionID,frameID,...
        PCpath, planeFilteringParameters,  PKFlag, compensateFactor);%returns a struct with a property frx - h world
% compute number of non accepted planes
Nnap=size(planeSegmentDescriptor.(['fr' num2str(frameID)]).values,2)-size(planeSegmentDescriptor.(['fr' num2str(frameID)]).acceptedPlanes,1);
% extract target identifiers based on type of plane
estimatedPlaneType=4; %to return IDs of [xzPlanes; xyPlanes; zyPlanes] in the next line
planeSegmentTargetID=extractTargetIDs_vcuboids(planeSegmentDescriptor,frameID,estimatedPlaneType);
% convert struct to vector localPlanes
localPlanes.values=loadPlanesFromIDs_d(planeSegmentDescriptor,planeSegmentTargetID);%vector in h world    
localPlanes.cameraPose=cameraPose;
[xzp_lp, xyp_lp, zyp_lp]=extractTypes_vcuboids(localPlanes.values);
localPlanes.xzIndex=xzp_lp;
localPlanes.xyIndex=xyp_lp;
localPlanes.zyIndex=zyp_lp;
end

