function myJoinedPlanes = findAndMergeTwins_partialOccluded(currentPlane,...
            myJoinedPlanes, joinedPlanesID, j, th_gc, th_angle)
%FINDANDMERGETWINS_PARTIALOCCLUDED Summary of this function goes here
%   Detailed explanation goes here
c1=computeC1_gcBtwnPlanes(currentPlane,myJoinedPlanes.fr0.values(joinedPlanesID(j,2)),th_gc);
c2=computeC2_angleBtwnL1lines(currentPlane,myJoinedPlanes.fr0.values(joinedPlanesID(j,2)),th_angle);

if currentPlane.topOccludedPlaneFlag | myJoinedPlanes.fr0.values(joinedPlanesID(j,2)).topOccludedPlaneFlag
    c3=true;
else
    c3=false;
end

if c1 & c2 & c3
    A1=computeArea(currentPlane);
    A2=computeArea(myJoinedPlanes.fr0.values(joinedPlanesID(j,2)));
    if A1>A2
        myJoinedPlanes.fr0.values(joinedPlanesID(j,2))=currentPlane;
    end
end
end

