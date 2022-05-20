function flag=conditionalAssignation_secondP(myPlanes, targetPlane, secondPlaneIndex, th_angle)
%CONDITIONALASSIGNATION Performs a conditional assignation of a secondPlane
%field with the value secondPlaneIndex
%   Detailed explanation goes here

flag=false;
flag_assignedP=searchBtwnAssignedPlanes(myPlanes,secondPlaneIndex);
if flag_assignedP%if secondPlanIndex is an assigned Plane
	flag=conditionedByAssignedPlane(myPlanes, targetPlane, secondPlaneIndex, th_angle);
else
	dtargetOfSecondPlane=retrieveTargetOfSecondPlane(myPlanes,secondPlaneIndex);
	if ~isempty(dtargetOfSecondPlane) %if secondPlaneIndex acts as a secondPlane of a different target 
		flag=conditionedBySecondPlane(myPlanes, targetPlane, secondPlaneIndex, dtargetOfSecondPlane, th_angle);
	else
		dtargetOfThirdPlane=retrieveTargetOfThirdPlane(myPlanes,secondPlaneIndex);
		if ~isempty(dtargetOfThirdPlane)%if secondPlaneIndex acts as a third plane of a different target
			flag=conditionedByThirdPlane(myPlanes, targetPlane, secondPlaneIndex, dtargetOfThirdPlane, th_angle);
        else
%             non conditional assignation
			myPlanes.(['fr' num2str(targetPlane(1))])(targetPlane(2)).secondPlaneID=secondPlaneIndex;
            flag=true;
		end
	end
end


end

