function matchID = computeRelationsBtwnEstimationsAndGT(e_m,theta,estimatedIDs,...
    gtIDs)
%COMPUTERELATIONSBTWNESTIMATIONSANDGT compute relationship between
%estimated ids and ground Truth ids. The matchID returns 1D indexes in the sequence
% estimated ID, groundTruth ID; For ground truth planes without
% relationship the IDs are [x 0]
Ne=size(e_m,1);
matchID=zeros(Ne,2);
matchID(:,1)=estimatedIDs;
for i=1:Ne
    rowi=e_m(i,:);
    indexGT=find(rowi<theta);
    if length(indexGT)>1
        indexGT=manageMultipleIndexGT(indexGT,rowi);
    end
%     update
    if ~isempty(indexGT)
        matchID(i,2)=gtIDs(indexGT);
    end
end
end

