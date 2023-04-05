function ID_mergedPlanes=mergeAndExtractIDs(localPlanes, ID_localPlanes, ID_globalPlanes)
%MERGEANDEXTRACTIDS Performa a merge between planes with identifiers
%ID_localPlanes and ID_globalPlanes. The merged version is converted to
%identifiers and this is the output of the function
%   Detailed explanation goes here

if ~isempty(ID_globalPlanes)
    if ~isempty(ID_localPlanes)
        dc_l=computeDistanceToCamera(localPlanes,ID_localPlanes);
        dc_g=computeDistanceToCamera(localPlanes,ID_globalPlanes);
        localPlanesV=loadPlanesFromIDs(localPlanes, ID_localPlanes);
        globalPlanesV=loadPlanesFromIDs(localPlanes, ID_globalPlanes);
        globalPlanesV=mergeIntoGlobalPlanes(localPlanesV, globalPlanesV, dc_l, dc_g);
        ID_mergedPlanes=extractIDsFromVector(globalPlanesV);
    else
        ID_mergedPlanes=ID_globalPlanes;
    end
else
    if ~isempty(ID_localPlanes)
        ID_mergedPlanes=ID_globalPlanes;
    else
        ID_mergedPlanes=[];
    end
end

end

