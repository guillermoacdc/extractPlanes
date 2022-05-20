    function cuboidDetection_naivy_v3(myPlanes, th_angle, acceptedPlanes)
%CUBOIDDETECTION_NAIVY Summary of this function goes here
%   Detailed explanation goes here

% _v2 is the identifier for the two dimensional version in the index of the
% planes. each index has the form [v1 v2], where v1 is the frame id and v2
% is the plane id
% _v3 adds conditional assignation to satisfy the restriction "one plane
% can belong to a single box"

%% second plane detection with conditional assignment
for i=1:size(acceptedPlanes,1)
    targetPlane=acceptedPlanes(i,:);
    if targetPlane(1)==3 & targetPlane(2)==11
        disp("stop the war")
    end

    searchSpace=setdiff_v2(acceptedPlanes,targetPlane);
    [secondPlaneIndex detectionFlag]=secondPlaneDetection_v4(targetPlane,searchSpace,myPlanes, th_angle);
    

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
                conditionalAssignation_secondP(myPlanes, targetPlane, secondPlaneIndex, th_angle);
            end
        else
            %conditional assignation - uses pass by reference
            conditionalAssignation_secondP(myPlanes, targetPlane, secondPlaneIndex, th_angle);
        end
    end
%         
%     
%     
%     if ~isempty(previous_secondPlaneIndex) & (myCriterion(1)|myCriterion(2))
%         disp(["case of v_7 error in plane " num2str(targetPlane(1,1)) "-" num2str(targetPlane(1,2))])
%         myPlanes.(['fr' num2str(targetPlane(1,1))])(targetPlane(1,2)).secondPlaneID=secondPlaneIndex;
%     end
end


%% third plane detection - uses pass by reference
thirdPlaneDetection_v2(myPlanes, acceptedPlanes, th_angle)
end

