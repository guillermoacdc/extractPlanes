function  cuboidDetection_pair(myPlanes, th_angle, acceptedPlanes, assignedPlanes)
%CUBOIDDETECTION_PAIR Summary of this function goes here
%   Detailed explanation goes here
assignedPlanesT=assignedPlanes;
%% second plane detection
for i=1:length(acceptedPlanes)
    targetPlane=acceptedPlanes(i);
%     check if there exist a previous secondPlaneID for the target. If so,
%     then add it to the assignedPlanesT or searchspace
    if ~isempty(myPlanes{targetPlane}.secondPlaneID)
        assignedPlanesT=[assignedPlanesT myPlanes{targetPlane}.secondPlaneID];
    end

    secondPlaneIndex=secondPlaneDetection(targetPlane,assignedPlanesT,myPlanes, th_angle);
    if(secondPlaneIndex~=-1)
        myPlanes{acceptedPlanes(i)}.secondPlaneID=secondPlaneIndex;
    end
    assignedPlanesT=assignedPlanes;
end


%% third plane detection - uses pass by reference
thirdPlaneDetection(myPlanes, acceptedPlanes, th_angle)
end


