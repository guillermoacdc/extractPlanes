function c2 = computeC2_mergedAreas(currentPlane,joinedPlane,th_angle)
%COMPUTEC2_MERGEDAREAS Summary of this function goes here
%   Detailed explanation goes here

% compute angle between normals
angle=computeAngleBtwnVectors(currentPlane.unitNormal,joinedPlane.unitNormal);

% compare angle with treshold
if angle<=th_angle
    c2=true;
else
    c2=false;
end

end

