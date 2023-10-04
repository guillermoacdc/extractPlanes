function [radii] = computeRaddi(rootPath,scene,frameID,planeType)
%COMPUTERADDI Computes the raddi as the max length of ppal diagonal between planes in
%the consolidation zone. The planes belong to a single type

[lengthBoundsTop, lengthBoundsP] =computeLengthBounds_v2(rootPath, scene, frameID);%in mm

switch planeType
    case 0
        L1=lengthBoundsTop(2);
        L2=lengthBoundsTop(4);
    otherwise % cases 1,2 and 3 are equal, update when discover how
        L1=lengthBoundsP(2);
        L2=lengthBoundsP(4);
end

radii=sqrt(L1^2+L2^2)/2;
end

