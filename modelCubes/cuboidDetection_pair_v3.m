function  cuboidDetection_pair_v3(myPlanes, th_angle, acceptedPlanes, assignedPlanes)
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

    [secondPlaneIndex, detectionFlag]=secondPlaneDetection_v4(targetPlane,assignedPlanesT,myPlanes, th_angle);
    
    
    if(detectionFlag)
        previous_secondPlaneIndex=myPlanes.(['fr' num2str(targetPlane(1,1))])(targetPlane(1,2)).secondPlaneID;
        if ~isempty(previous_secondPlaneIndex)
            myCriterion=secondPlaneIndex~=previous_secondPlaneIndex;
%             if secondPlaneIndex is different than previous_secondPlaneIndex
            if myCriterion(1) | myCriterion(2)
%                 disp(["case of conditional assignation " num2str(targetPlane(1,1)) "-" num2str(targetPlane(1,2))])
                %conditional assignation - uses pass by reference
                conditionalAssignation_secondP(myPlanes, targetPlane, secondPlaneIndex, th_angle);
            end
        else
            %conditional assignation - uses pass by reference
            conditionalAssignation_secondP(myPlanes, targetPlane, secondPlaneIndex, th_angle);
        end
    end

    assignedPlanesT=assignedPlanes;
end


%% third plane detection - uses pass by reference
thirdPlaneDetection_v2(myPlanes, acceptedPlanes, th_angle)
end


