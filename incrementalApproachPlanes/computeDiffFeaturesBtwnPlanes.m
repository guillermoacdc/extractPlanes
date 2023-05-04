function [angleBtwnNormals, absDiffD, DistanceBtwnGC, DistanceBtwnGCh] = computeDiffFeaturesBtwnPlanes(planeVector1,id1, planeVector2, id2)
%COMPUTEDIFFFEATURESBTWNPLANES Computes differences between pair of plane
%objects. Designed to define features to merge common planes between frames
%or in the same frame
%   Detailed explanation goes here

% identify the index in the plane vector
index1=extractIndexFromIDs(planeVector1,id1(1), id1(2));
index2=extractIndexFromIDs(planeVector2,id2(1), id2(2));
% compute the outputs
angleBtwnNormals=computeAngleBtwnVectors(planeVector1(index1).unitNormal,planeVector2(index2).unitNormal);
absDiffD=abs(planeVector1(index1).D-planeVector2(index2).D);
DistanceBtwnGC=norm(planeVector1(index1).geometricCenter-planeVector2(index2).geometricCenter);
DistanceBtwnGCh=abs(planeVector1(index1).geometricCenter(2)-planeVector2(index2).geometricCenter(2));


end


