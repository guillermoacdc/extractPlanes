function estimatedPlanesID=extractTargetIDs_woutPK(estimatedPlanesfr,frameID,planeType, th_angle)
%EXTRACTTARGETIDS Summary of this function goes here
%   Detailed explanation goes here

    [xzPlanes, xyzyPlanes] =extractTypes_woutPK(estimatedPlanesfr,...
        estimatedPlanesfr.(['fr' num2str(frameID)]).acceptedPlanes, th_angle); 
    switch planeType
        case 0
            estimatedPlanesID = xzPlanes;
        case 1
            estimatedPlanesID = xyzyPlanes;
        case 2
            estimatedPlanesID = xyzyPlanes;
    end

end

