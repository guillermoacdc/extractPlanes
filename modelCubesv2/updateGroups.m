function [group_tpp, group_tp, group_s]=updateGroups(globalPlanes)
group_s=[];
group_tp=[];
group_tpp=[];

Np=length(globalPlanes);
for i=1:Np
    plane=globalPlanes(i);
    if isempty(plane.secondPlaneID) 
        group_s=[group_s, i];
    else
        if isempty(plane.thirdPlaneID)
            group_tp=[group_tp, i];
        else
            group_tpp=[group_tpp, i];
        end
    end
end
% extract second and third PlaneIDs from globlaPlanes
[secondPlaneIDs, thirdPlaneIDs] = extractSecondAndThirdPlaneIDs(globalPlanes);
% find indexes of extracted IDs from group_s
idx1=myFindIterative(group_s, secondPlaneIDs);
idx2=myFindIterative(group_s, thirdPlaneIDs);
idx=[idx1, idx2];
% delete the found indexes
if ~isempty(idx)
    group_s(idx)=[];
end
end