function  cuboidDetection_pair_v4(myPlanes, th_angle, ...
    acceptedPlanes, assignedPlanes, conditionalAssignationFlag)
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

    if conditionalAssignationFlag
    % conditional assignation of secondPlaneIndex
        assignationFlag=conditionalAssignationSecondPlane(detectionFlag,...
        myPlanes,targetPlane,secondPlaneIndex, th_angle);
    else
        if detectionFlag
            myPlanes.(['fr' num2str(targetPlane(1))])(targetPlane(2)).secondPlaneID=secondPlaneIndex;
        end
    end

    assignedPlanesT=assignedPlanes;
end


%% --third plane detection with conditional assignment--
% init vars

%% create exemplar set
exemplarSet=zeros(size(acceptedPlanes,1),3);
for i=1:size(acceptedPlanes,1)
    frame_ss=acceptedPlanes(i,1);
    element_ss=acceptedPlanes(i,2);    
    exemplarSet(i,:)=myPlanes.(['fr' num2str(frame_ss)])(element_ss).unitNormal;
end
%% create thirdPlaneExemplar
secondPlaneT=[];
for i=1:size(acceptedPlanes,1)
    frame_ss=acceptedPlanes(i,1);
    element_ss=acceptedPlanes(i,2); 
    if(~isempty(myPlanes.(['fr' num2str(frame_ss)])(element_ss).secondPlaneID))
        secondFrame=myPlanes.(['fr' num2str(frame_ss)])(element_ss).secondPlaneID(1);
        secondElement=myPlanes.(['fr' num2str(frame_ss)])(element_ss).secondPlaneID(2);
        secondPlaneT=[secondPlaneT; frame_ss,element_ss,...
            secondFrame, secondElement];
    end
end
% eliminate duplicates; we asume the pair (1,3) is duplicated with pair (3,1)
[uniqueIndexes ic]= myUnique_v2(secondPlaneT);
secondPlaneT_unique=secondPlaneT(uniqueIndexes,:);
% assembly in the thirdPlaneExemplar structure: (id, secondPlaneid, crossPd)
for i=1:size(secondPlaneT_unique,1)
    thirdPlaneExemplar.id=secondPlaneT_unique(i,1:2);
    thirdPlaneExemplar.secondPlaneId=secondPlaneT_unique(i,3:4);
    a=myPlanes.(['fr' num2str(thirdPlaneExemplar.id(1))])(thirdPlaneExemplar.id(2)).unitNormal;
    b=myPlanes.(['fr' num2str(thirdPlaneExemplar.secondPlaneId(1))])(thirdPlaneExemplar.secondPlaneId(2)).unitNormal;
    thirdPlaneExemplar.crossPd=cross(a,b);
    tPExemplar{i}=thirdPlaneExemplar;
end

%% perform search 
for i=1:size(secondPlaneT_unique,1)
    targetP=secondPlaneT_unique(i,1:2);
    secondP=secondPlaneT_unique(i,3:4);
    [thirdPlaneIndex detectionFlag]=thirdPlaneDetection_v3(myPlanes, ...
        targetP, secondP, acceptedPlanes, tPExemplar{i}.crossPd, th_angle, exemplarSet);
    if detectionFlag %update with conditional assignation for third plane
        % retrieve duplicates from unique filter
        dup=find(ic==i);
        % save the thirdplane in the structure cell
        for j=1:length(dup)
            targetFrame=secondPlaneT(dup(j),1);
			targetElement=secondPlaneT(dup(j),2);
			myPlanes.(['fr' num2str(targetFrame)])(targetElement).thirdPlaneID=thirdPlaneIndex;
        end
    end

end
end


