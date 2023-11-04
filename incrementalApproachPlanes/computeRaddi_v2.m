function [radii] = computeRaddi_v2(rootPath,scene,frameID)
%COMPUTERADDI Computes the raddi as the max length of ppal diagonal between planes in
%the consolidation zone. The planes belong to a single type
% _v2: outputs raddi for both top and perpendicular planes
[lengthBoundsTop, lengthBoundsP] =computeLengthBounds_v2(rootPath, scene, frameID);%in mm


L1=lengthBoundsTop(2);
L2=lengthBoundsTop(4);
    radii.top=sqrt(L1^2+L2^2)/2;
L1=lengthBoundsP(2);
L2=lengthBoundsP(4);
    radii.perpendicular=sqrt(L1^2+L2^2)/2;

end

