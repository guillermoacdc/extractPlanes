function candidate = searchCandidates_geometriCenterRelationships(searchSpace, targetIndex, globalPlanes)
%SEARCHCANDIDATES_geometriCenterRelationships search candidates by using 
% geometric center constraints
%   Detailed explanation goes here
% Assumption: target index is an index of a top plane
candidate=[];
k=1;
Nss=length(searchSpace);
for i=1:Nss
    element_ss=searchSpace(i);
%     gcRelationShipFlag=gcRelationshipCheck(globalPlanes(targetIndex),...
%         globalPlanes(element_ss));
gcRelationShipFlag=gcRelationshipCheck_v2(globalPlanes(targetIndex),...
        globalPlanes(element_ss));

    if (gcRelationShipFlag)
        candidate(k,:)=element_ss;
        k=k+1;
    end
end
end

