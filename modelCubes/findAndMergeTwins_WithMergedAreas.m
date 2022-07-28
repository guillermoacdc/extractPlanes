function [myJoinedPlanes] = findAndMergeTwins_WithMergedAreas(currentPlane,...
            myJoinedPlanes, joinedPlanesID, j, th_IOU, th_angle)

%FINDANDMERGETWINS_WITHMERGEDAREAS Summary of this function goes here
%   Detailed explanation goes here
c1=computeC1_mergedAreas(currentPlane,myJoinedPlanes.fr0.values(joinedPlanesID(j,2)),th_IOU);
c2=computeC2_angle(currentPlane,myJoinedPlanes.fr0.values(joinedPlanesID(j,2)),th_angle);

if c1 & c2
    A1=computeArea(currentPlane);
    A2=computeArea(mmyJoinedPlanes.fr0.values(joinedPlanesID(j,2)));
    if A1>A2
       myJoinedPlanes.fr0.values(joinedPlanesID(j,2))= currentPlane;
    end
end

end