function  cuboidDetection_pair_v6(myPlanes, th_angle, ...
    planesIDs, searchSpace, conditionalAssignationFlag)
%CUBOIDDETECTION_PAIR Summary of this function goes here
%   Detailed explanation goes here
% _v6 uses the structure myPlanes with the fields (1) camerapose, (2) values
searchSpaceT=searchSpace;

%% second plane detection
for i=1:size(planesIDs,1)
    targetFrame=planesIDs(i,1);
    targetElement=planesIDs(i,2);    
%     check if there exist a previous secondPlaneID for the target. If so,
%     then add it to the searchSpaceT or searchspace
    if ~isempty(myPlanes.(['fr' num2str(targetFrame)]).values(targetElement).secondPlaneID)
%         update by adding the second plane just if doesnt exist, to avoid
%         duplicates
        secondFrame=myPlanes.(['fr' num2str(targetFrame)]).values(targetElement).secondPlaneID(1);
        secondElement=myPlanes.(['fr' num2str(targetFrame)]).values(targetElement).secondPlaneID(2);
        searchSpaceT=[searchSpaceT; myPlanes.(['fr' num2str(secondFrame)]).values(secondElement).getID];
    end
    targetPlane=[targetFrame targetElement];

    [secondPlaneIndex, detectionFlag]=secondPlaneDetection_v5(targetPlane,...
        searchSpaceT,myPlanes, th_angle);
% assignation
    if conditionalAssignationFlag
        assignationFlag=conditionalAssignationSecondPlane(detectionFlag,...
        myPlanes,targetPlane,secondPlaneIndex, th_angle);
    else
        if detectionFlag
            myPlanes.(['fr' num2str(targetPlane(1))]).values(targetPlane(2)).secondPlaneID=secondPlaneIndex;
        end
    end
% restaure the original searchSpace
    searchSpaceT=searchSpace;
end


%% --third plane detection with conditional assignment--
% init vars

%% create exemplar set
exemplarSet=zeros(size(planesIDs,1),3);
for i=1:size(planesIDs,1)
    frame_ss=planesIDs(i,1);
    element_ss=planesIDs(i,2);    
    exemplarSet(i,:)=myPlanes.(['fr' num2str(frame_ss)]).values(element_ss).unitNormal;
end
searchSpace3P=KDTreeSearcher(exemplarSet);
%% create thirdPlaneExemplar
secondPlaneT=[];
for i=1:size(planesIDs,1)
    frame_ss=planesIDs(i,1);
    element_ss=planesIDs(i,2); 
    if(~isempty(myPlanes.(['fr' num2str(frame_ss)]).values(element_ss).secondPlaneID))
        secondFrame=myPlanes.(['fr' num2str(frame_ss)]).values(element_ss).secondPlaneID(1);
        secondElement=myPlanes.(['fr' num2str(frame_ss)]).values(element_ss).secondPlaneID(2);
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
    a=myPlanes.(['fr' num2str(thirdPlaneExemplar.id(1))]).values(thirdPlaneExemplar.id(2)).unitNormal;
    b=myPlanes.(['fr' num2str(thirdPlaneExemplar.secondPlaneId(1))]).values(thirdPlaneExemplar.secondPlaneId(2)).unitNormal;
    thirdPlaneExemplar.crossPd=cross(a,b);
    tPExemplar{i}=thirdPlaneExemplar;
end

%% perform search 
for i=1:size(secondPlaneT_unique,1)
    targetP=secondPlaneT_unique(i,1:2);
    secondP=secondPlaneT_unique(i,3:4);
    [thirdPlaneIndex detectionFlag]=thirdPlaneDetection_v5(myPlanes, ...
        targetP, secondP, planesIDs, tPExemplar{i}.crossPd, th_angle, searchSpace3P);
%     disp()
    if detectionFlag %update with conditional assignation for third plane
        % retrieve duplicates from unique filter
        dup=find(ic==i);
        % save the thirdplane in the structure cell
        for j=1:length(dup)
            targetFrame=secondPlaneT(dup(j),1);
			targetElement=secondPlaneT(dup(j),2);
			myPlanes.(['fr' num2str(targetFrame)]).values(targetElement).thirdPlaneID=thirdPlaneIndex;
        end
    end

end
end


