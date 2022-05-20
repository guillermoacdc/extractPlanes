function cuboidDetection_naivy_v4(myPlanes, th_angle, planesIDs, conditionalAssignationFlag)
%CUBOIDDETECTION_NAIVY Summary of this function goes here
%   Detailed explanation goes here
% planesIDs. List of plane IDs that will be processed by the function
% _v2 is the identifier for the two dimensional version in the index of the
% planes. each index has the form [v1 v2], where v1 is the frame id and v2
% is the plane id
% _v3 adds conditional assignation to satisfy the restriction "one plane
% can belong to a single box"

%% --second plane detection with conditional assignment--
for i=1:size(planesIDs,1)
    targetPlane=planesIDs(i,:);
%     if targetPlane(1)==3 & targetPlane(2)==11
%         disp("stop the war")
%     end
    searchSpace=setdiff_v2(planesIDs,targetPlane);
    [secondPlaneIndex detectionFlag]=secondPlaneDetection_v4(targetPlane,...
        searchSpace,myPlanes, th_angle);

% assignation    
    if conditionalAssignationFlag 
    % conditional assignation of secondPlaneIndex
        assignationFlag=conditionalAssignationSecondPlane(detectionFlag,...
        myPlanes,targetPlane,secondPlaneIndex, th_angle);
    else
        if detectionFlag
            myPlanes.(['fr' num2str(targetPlane(1))])(targetPlane(2)).secondPlaneID=secondPlaneIndex;
        end    
    end


end


%% --third plane detection with conditional assignment--

%% create exemplar set
exemplarSet=zeros(size(planesIDs,1),3);
for i=1:size(planesIDs,1)
    frame_ss=planesIDs(i,1);
    element_ss=planesIDs(i,2);    
    exemplarSet(i,:)=myPlanes.(['fr' num2str(frame_ss)])(element_ss).unitNormal;
end
modelTree=KDTreeSearcher(exemplarSet);

%% create thirdPlaneExemplar
secondPlaneT=[];
for i=1:size(planesIDs,1)
    frame_ss=planesIDs(i,1);
    element_ss=planesIDs(i,2); 
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
for i=1:size(tPExemplar,2)
%     targetP=secondPlaneT_unique(i,1:2);
%     secondP=secondPlaneT_unique(i,3:4);
    targetP=tPExemplar{i}.id;
    secondP=tPExemplar{i}.secondPlaneId;
    targetNormal=tPExemplar{i}.crossPd;
%     [thirdPlaneIndex detectionFlag]=thirdPlaneDetection_v3(myPlanes, ...
%         targetP, secondP, planesIDs, targetNormal, th_angle, exemplarSet);
    [thirdPlaneIndex detectionFlag]=thirdPlaneDetection_v4(myPlanes, ...
        targetP, secondP, planesIDs, targetNormal, th_angle, modelTree);
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

