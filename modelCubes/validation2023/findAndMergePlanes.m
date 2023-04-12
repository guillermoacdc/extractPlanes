function myJoinedPlanes = findAndMergePlanes(joinedPlanesID,...
    currentPlanesID, myPlanes,myJoinedPlanes, th_merge)
%FINDANDMERGEPLANES Summary of this function goes here
%   Detailed explanation goes here
% th_merge=[th_gc, th_angle, th_IOU_min, th_IOU_max, th_dlower, th_dupper];
% 
th_gc=th_merge(1);
th_angle=th_merge(2);
th_IOU_min=th_merge(3);
th_IOU_max=th_merge(4);
th_dlower=th_merge(5);
th_dupper=th_merge(6);
topFlag=false;
if ~myPlanes.(['fr' num2str(currentPlanesID(1,1))]).values(currentPlanesID(1,2)).type
    topFlag=true;
end

N=size(currentPlanesID,1);
M=size(joinedPlanesID,1);
for i=1:N
    currentPlane=myPlanes.(['fr' num2str(currentPlanesID(i,1))]).values(currentPlanesID(i,2));

    for j=1:M
        d=computeDistanceToCamera(myPlanes,currentPlane.getID);
        myJoinedPlanes=findAndMergeTwins_WoutOcclusion(currentPlane,...
            myJoinedPlanes, joinedPlanesID, j, th_dlower, th_dupper, d);

        myJoinedPlanes=findAndMergeTwins_WithMergedAreas(currentPlane,...
            myJoinedPlanes, joinedPlanesID, j, th_IOU, 2*th_angle);
        if (topFlag)
            myJoinedPlanes=findAndMergeTwins_partialOccluded(currentPlane,...
                    myJoinedPlanes, joinedPlanesID, j, 10*th_gc, 3*th_angle);
        end
    end
end

end

