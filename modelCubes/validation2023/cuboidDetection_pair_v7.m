function  cuboidDetection_pair_v7(myPlanes, th_angle, ...
    planesIDs, searchSpace, conditionalAssignationFlag)
%CUBOIDDETECTION_PAIR Summary of this function goes here
%   Detailed explanation goes here
% _v6 uses the structure myPlanes with the fields (1) camerapose, (2) values
% _v7 update the strategy to search the third plane. Uses type and
% planeTilt as criterion to create the searchspace
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

% create table with couples 
couples=[];
for i=1:size(planesIDs,1)
    frame_ss=planesIDs(i,1);
    element_ss=planesIDs(i,2); 
    if(~isempty(myPlanes.(['fr' num2str(frame_ss)]).values(element_ss).secondPlaneID))
        secondFrame=myPlanes.(['fr' num2str(frame_ss)]).values(element_ss).secondPlaneID(1);
        secondElement=myPlanes.(['fr' num2str(frame_ss)]).values(element_ss).secondPlaneID(2);
        couples=[couples; frame_ss,element_ss,...
            secondFrame, secondElement];
    end
end
% classify couples
[couple1, couple2, couple3] = classifyCouples(couples,myPlanes);
% extract types
[ss_couple3 ss_couple2 ss_couple1]=extractTypes(myPlanes, searchSpace);
% perform the search

if ~isempty(couple1) & ~isempty(ss_couple1)
    searchThirdPlane(myPlanes, couple1, ss_couple1, th_angle);%designed to use pass by reference in myPlanes
end

if ~isempty(couple2) & ~isempty(ss_couple2)
    searchThirdPlane(myPlanes, couple2, ss_couple2, th_angle);
end

if ~isempty(couple3) & ~isempty(ss_couple3)
    searchThirdPlane(myPlanes, couple3, ss_couple3, th_angle);
end


end


