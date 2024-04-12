function  globalPlanes=cuboidDetection_pair_v8(globalPlanes, th_angle, ...
    topPlaneIndexes, searchSpaceIndex, conditionalAssignationFlag)
%CUBOIDDETECTION_PAIR Summary of this function goes here
%   Detailed explanation goes here
% _v6 uses the structure globalPlanes with the fields (1) camerapose, (2) values
% _v7 update the strategy to search the third plane. Uses type and
% planeTilt as criterion to create the searchSpaceIndex
% v8: returns globalPlanes structure to avoid lost the modifications on
% fields second and thirdPlane ID; This was not necessary in windows until
% 04/2024
searchSpaceT=searchSpaceIndex;

%% second plane detection
for i=1:size(topPlaneIndexes,1)
%     check if there exist a previous secondPlaneID for the target. If so,
%     then add it to the searchSpaceT or searchSpaceIndex
%     if ~isempty(globalPlanes.values(topPlaneIndexes).secondPlaneID)
% %         update by adding the second plane just if doesnt exist, to avoid
% %         duplicates
%         secondFrame=globalPlanes.(['fr' num2str(targetFrame)]).values(targetElement).secondPlaneID(1);
%         secondElement=globalPlanes.(['fr' num2str(targetFrame)]).values(targetElement).secondPlaneID(2);
%         searchSpaceT=[searchSpaceT; globalPlanes.(['fr' num2str(secondFrame)]).values(secondElement).getID];
%     end
%     targetPlane=[targetFrame targetElement];
    targetIndex=topPlaneIndexes(i);
    [secondPlaneIndex, detectionFlag]=secondPlaneDetection_v5(targetIndex,...
        searchSpaceT,globalPlanes, th_angle);
% assignation
    if conditionalAssignationFlag
        assignationFlag=conditionalAssignationSecondPlane(detectionFlag,...
        globalPlanes,targetPlane,secondPlaneIndex, th_angle);
    else
        if detectionFlag
            globalPlanes(targetIndex).secondPlaneID=secondPlaneIndex;%acá se mezcla ID con index. Lo ideal será actualizar el nombre de la propiedad con el argumento secondPlaneIndex
        end
    end
% restaure the original searchSpaceIndex
    searchSpaceT=searchSpaceIndex;
end


%% --third plane detection with conditional assignment--

% create table with couples 
couples=[];
for i=1:size(topPlaneIndexes,1)
    element_ss=topPlaneIndexes(i);
    if(~isempty(globalPlanes(element_ss).secondPlaneID))
        couples=[couples; element_ss, globalPlanes(element_ss).secondPlaneID];
    end
end
% classify couples
[couple1, couple2, couple3] = classifyCouples_vcuboids(couples,globalPlanes);
% extract types
[ss_couple3, ss_couple2, ss_couple1]=extractTypes_vcuboids(globalPlanes);
% perform the search

if ~isempty(couple1) & ~isempty(ss_couple1)
    globalPlanes=searchThirdPlane_v2(globalPlanes, couple1, ss_couple1, th_angle);%designed to use pass by reference in globalPlanes
end

if ~isempty(couple2) & ~isempty(ss_couple2)
    globalPlanes=searchThirdPlane_v2(globalPlanes, couple2, ss_couple2, th_angle);
end

if ~isempty(couple3) & ~isempty(ss_couple3)
    globalPlanes=searchThirdPlane_v2(globalPlanes, couple3, ss_couple3, th_angle);
end


end


