function flag=conditionalAssignation(myPlanes, targetPlane, secondPlaneIndex)
%CONDITIONALASSIGNATION Summary of this function goes here
%   Detailed explanation goes here
flag_assignedP=searchBtwnAssignedPlanes(myPlanes,secondPlaneIndex);
if flag_assignedP
	flag=conditionedByAssignedPlane(myPlanes, targetPlane, secondPlaneIndex);
else
	candidateAs_secondP=searchBtwnSecondPlanes(myPlanes,secondPlaneIndex);
	if ~isempty(candidateAs_secondP)
		flag=conditionedBySecondPlane(myPlanes, targetPlane, secondPlaneIndex, candidateAs_secondP);
	else
		candidateAs_thirdP=searchBtwnThirdPlanes(myPlanes,secondPlaneIndex);
		if ~isempty(candidateAs_thirdP)
			flag=conditionedByThirdPlane(myPlanes, targetPlane, secondPlaneIndex, candidateAs_thirdP);
        else
%             non conditional assignation
			myPlanes.(['fr' num2str(targetPlane(1))])(targetPlane(2)).secondPlaneID=secondPlaneIndex;
		end
	end
end


end

