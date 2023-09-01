function [refPlaneDescriptor] = computeReferencePoseBySession(sessionID,...
    frameID, planeID, planeFilteringParameters)
%COMPUTEREFERENCEPOSEBYSESSION Retorna los descriptores del plano usado
%como referencia en una sesion/frame predefinida


[dataSetPath, ~, PCpath]=computeMainPaths(sessionID);
% [lengthBoundsTop, lengthBoundsP] =computeLengthBounds_v2(dataSetPath, sessionID);%[L1min L1max L2min L2max]

estimatedPlanesfr=loadExtractedPlanes(dataSetPath,sessionID,frameID,...
        PCpath, planeFilteringParameters);%returns a struct with a property frx - h world
% extract target identifiers based on type of plane
%     estimatedPlanesID=extractTargetIDs(estimatedPlanesfr,frameID,estimatedPlaneType);
refPlaneDescriptor=loadPlanesFromIDs(estimatedPlanesfr,[frameID planeID]);%vector in h world

end

