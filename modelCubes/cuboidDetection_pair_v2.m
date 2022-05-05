function  cuboidDetection_pair_v2(myPlanes, th_angle, acceptedPlanes, assignedPlanes)
%CUBOIDDETECTION_PAIR Summary of this function goes here
%   Detailed explanation goes here
assignedPlanesT=assignedPlanes;
%% second plane detection
for i=1:size(acceptedPlanes,1)
    targetFrame=acceptedPlanes(i,1);
    targetElement=acceptedPlanes(i,2);    
%     check if there exist a previous secondPlaneID for the target. If so,
%     then add it to the assignedPlanesT or searchspace
    if ~isempty(myPlanes.(['fr' num2str(targetFrame)])(targetElement).secondPlaneID)
        secondFrame=myPlanes.(['fr' num2str(targetFrame)])(targetElement).secondPlaneID(1);
        secondElement=myPlanes.(['fr' num2str(targetFrame)])(targetElement).secondPlaneID(2);
        assignedPlanesT=[assignedPlanesT; myPlanes.(['fr' num2str(secondFrame)])(secondElement).getID];
    end
    targetPlane=[targetFrame targetElement];
    secondPlaneIndex=secondPlaneDetection_v2(targetPlane,assignedPlanesT,myPlanes, th_angle);
    if(secondPlaneIndex~=-1)
        myPlanes.(['fr' num2str(targetFrame)])(targetElement).secondPlaneID=secondPlaneIndex;
    end

    assignedPlanesT=assignedPlanes;
end


%% third plane detection - uses pass by reference
thirdPlaneDetection_v2(myPlanes, acceptedPlanes, th_angle)
end


