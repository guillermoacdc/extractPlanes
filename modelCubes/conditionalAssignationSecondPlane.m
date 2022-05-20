function assignationFlag = conditionalAssignationSecondPlane(detectionFlag, myPlanes,targetPlane,secondPlaneIndex, th_angle)
%CONDITIONALASSIGNATIONSECONDPLANE Summary of this function goes here
%   Detailed explanation goes here
assignationFlag=false;
if(detectionFlag)
    %         validate if targetPlane is a second or thirdPlane of another
    %       object, if so, then break that relationship
    targetOfASecondPlane=retrieveTargetOfSecondPlane(myPlanes,targetPlane);
    targetOfAThirdPlane=retrieveTargetOfThirdPlane(myPlanes, targetPlane);

    if ~isempty(targetOfASecondPlane)
        c1= targetOfASecondPlane~=secondPlaneIndex;
        if c1(1) | c1(2)
            myPlanes.(['fr' num2str(targetOfASecondPlane(1))])(targetOfASecondPlane(2)).secondPlaneID=[];
        end
    else
        if ~isempty(targetOfAThirdPlane)
            c2=targetOfAThirdPlane~=secondPlaneIndex;
            if c2(1) | c2(2)
                myPlanes.(['fr' num2str(targetOfAThirdPlane(1))])(targetOfAThirdPlane(2)).thirdPlaneID=[];
            end
        end
    end

% validate if there exists a previous second plane, if so, validate that is
% different that the current one to apply the assignation
        previous_secondPlaneIndex=myPlanes.(['fr' num2str(targetPlane(1,1))])(targetPlane(1,2)).secondPlaneID;
        if ~isempty(previous_secondPlaneIndex)
            myCriterion=secondPlaneIndex~=previous_secondPlaneIndex;
%             if secondPlaneIndex is different than previous_secondPlaneIndex
            if myCriterion(1) | myCriterion(2)
                disp(["case of conditional assignation " num2str(targetPlane(1,1)) "-" num2str(targetPlane(1,2))])
                %conditional assignation - uses pass by reference
                assignationFlag=conditionalAssignation_secondP(myPlanes, targetPlane, secondPlaneIndex, th_angle);
            end
        else
            %conditional assignation - uses pass by reference
            assignationFlag=conditionalAssignation_secondP(myPlanes, targetPlane, secondPlaneIndex, th_angle);
        end
end

end

