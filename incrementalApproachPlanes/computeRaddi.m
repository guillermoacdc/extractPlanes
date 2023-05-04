function [radii] = computeRaddi(rootPath,scene,frameID,planeType)
%COMPUTERADDI Computes the min length of ppal diagonal between planes in
%the consolidation zone. The planes belong to a single type

[lengthBoundsTop, lengthBoundsP] =computeLengthBounds_v2(rootPath, scene, frameID);%in mm

switch planeType
    case 0
        L1min=lengthBoundsTop(1);
        L2min=lengthBoundsTop(3);
    case [1, 2]
        L1min=lengthBoundsP(1);
        L2min=lengthBoundsP(3);
end

radii=sqrt(L1min^2+L2min^2)/2;
end

