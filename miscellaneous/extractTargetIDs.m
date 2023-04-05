function estimatedPlanesID=extractTargetIDs(estimatedPlanesfr,frameID,planeType)
%EXTRACTTARGETIDS Summary of this function goes here
%   Detailed explanation goes here

    [xzPlanes, xyPlanes, zyPlanes] =extractTypes(estimatedPlanesfr,...
        estimatedPlanesfr.(['fr' num2str(frameID)]).acceptedPlanes); 
    switch planeType
        case 0
            estimatedPlanesID = xzPlanes;
        case 1
            estimatedPlanesID = xyPlanes;
        case 2
            estimatedPlanesID = zyPlanes;
    end

end

