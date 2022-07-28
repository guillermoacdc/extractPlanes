function [myJoinedPlanes] = findAndMergeTwins_WoutOcclusion(currentPlane,...
            myJoinedPlanes, joinedPlanesID, j, th_angle, th_dlower, th_dupper, d)
%FINDANDMERGETWINS_WOUTOCCLUSION Summary of this function goes here
%   Detailed explanation goes here

c1=computeC1_gcBtwnPlanes(currentPlane,joinedPlane,th_gc);
c2=computeC2_angle(currentPlane,myJoinedPlanes.fr0.values(joinedPlanesID(j,2)),th_angle);

if c1 & c2
    if d>th_dlower & d<th_dupper
        myJoinedPlanes.fr0.values(joinedPlanesID(j,2))=currentPlane;
    end
end


