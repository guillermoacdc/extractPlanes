    function cuboidDetection_naivy_v2(myPlanes, th_angle, acceptedPlanes)
%CUBOIDDETECTION_NAIVY Summary of this function goes here
%   Detailed explanation goes here

% _v2 is the identifier for the two dimensional version in the index of the
% planes. each index has the form [v1 v2], where v1 is the frame id and v2
% is the plane id

%% second plane detection
for i=1:size(acceptedPlanes,1)
    targetPlane=acceptedPlanes(i,:);
    searchSpace=setdiff_v2(acceptedPlanes,targetPlane);
    [secondPlaneIndex detectionFlag]=secondPlaneDetection_v3(targetPlane,searchSpace,myPlanes, th_angle);

    if(detectionFlag)
        previous_secondPlaneIndex=myPlanes.(['fr' num2str(targetPlane(1,1))])(targetPlane(1,2)).secondPlaneID;
        if ~isempty(previous_secondPlaneIndex)
            myCriterion=secondPlaneIndex~=previous_secondPlaneIndex;
            if myCriterion(1) | myCriterion(2)
                disp(["case of v_7 error in plane " num2str(targetPlane(1,1)) "-" num2str(targetPlane(1,2))])
            end
        else
            myPlanes.(['fr' num2str(targetPlane(1,1))])(targetPlane(1,2)).secondPlaneID=secondPlaneIndex; 
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

