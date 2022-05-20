function [myBoxes, flagFirstBox] = createBoxes_v3(myPlanes, localAssignedP, myBoxes)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% i_offset=size(myBoxes,1);
flagFirstBox=0;
boxIDs=[];
%% create boxID vector for each element in  localassignedP. The vector has as components [a b c], where 
% (a) is the index of the top plane
% (b) is the index of a perpendicular plane
% (c) is the index of a perpendicular plane
% with b<c
for i=1:size(localAssignedP,1)
%         extract IDs that belong to a common box in tempIDs
    targetFrame=localAssignedP(i,1);
    targetElement=localAssignedP(i,2);
    secondFrame=myPlanes.(['fr' num2str(targetFrame)])(targetElement).secondPlaneID(1);
    secondElement=myPlanes.(['fr' num2str(targetFrame)])(targetElement).secondPlaneID(2);
    thirdFrame=myPlanes.(['fr' num2str(targetFrame)])(targetElement).thirdPlaneID(1);
    thirdElement=myPlanes.(['fr' num2str(targetFrame)])(targetElement).thirdPlaneID(2);

    tempIDs=[localAssignedP(i,:);...
    myPlanes.(['fr' num2str(secondFrame)])(secondElement).getID;...
    myPlanes.(['fr' num2str(thirdFrame)])(thirdElement).getID];
% create type vector; with binary values
    typeVector=[myPlanes.(['fr' num2str(targetFrame)])(targetElement).type,...
    myPlanes.(['fr' num2str(secondFrame)])(secondElement).type,...
    myPlanes.(['fr' num2str(thirdFrame)])(thirdElement).type];
% find index of parallel plane. index of plane (a)
    zeroIndex=find(typeVector==0);%we expect a single retrieve
% if index is different than 1, swap values with 1
%     if(i==12)
%         disp("stop the world");%to track the two top planes error
%     end
    if (zeroIndex~=1)
%         swap with 1
       temp=tempIDs(zeroIndex,:);
       tempIDs(zeroIndex,:)=tempIDs(1,:);
       tempIDs(1,:)=temp;
    end

    if(tempIDs(2,2)>tempIDs(3,2))%sort of indexes (b) and (c)
%         swap
        temp=tempIDs(3,:);
        tempIDs(3,:)=tempIDs(2,:);
        tempIDs(2,:)=temp;
    end

    boxIDs=[boxIDs; reshape(tempIDs',[1,6])];
end
%% detect duplicates in boxIDs where an entry [a b c] is duplicated with [a b c]
% extract ids of previous detected boxes
previousIDs=extractBoxIds(myBoxes);
allBoxesIDs=[boxIDs; previousIDs];
[~,indexes, ic]=unique(allBoxesIDs,'rows','stable');
allBoxesIDs_unique=allBoxesIDs(indexes,:);

for i=1:size(allBoxesIDs_unique,1)
    mySingleBox=createBoxObject(myPlanes,allBoxesIDs_unique(i,:),i);
    myBoxes{i}=mySingleBox;
end


% localBoxes=boxIDs;


end

