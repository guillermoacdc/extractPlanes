function estimatedPlanesID=extractTargetIDs(estimatedPlanesfr,frameID,planeType)
%EXTRACTTARGETIDS Extracts ID of a plane that belongs to the
%planeType Group

% planeType Groups:
%{0 for xzPlanes, 1 for xyPlanes, 2 for zyPlanes, 3 for zyPlanes and 
% zyPlanes} in qh_c coordinate system
    [xzPlanes, xyPlanes, zyPlanes] =extractTypes(estimatedPlanesfr,...
        estimatedPlanesfr.(['fr' num2str(frameID)]).acceptedPlanes); 
    switch planeType
        case 0
            estimatedPlanesID = xzPlanes;
        case 1
            estimatedPlanesID = xyPlanes;
        case 2
            estimatedPlanesID = zyPlanes;
        case 3
            estimatedPlanesID = [xyPlanes; zyPlanes];
    end

end

