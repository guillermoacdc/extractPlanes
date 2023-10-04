function matchID=computeR_Estimated_GT_ID(eADD_m,theta,planeIDs,gtPlanes)
%COMPARE_EADDVSTHETA compute relationship between estimated planeID
% and ground Truth planeID. The matchID returns 2D indexes in the sequence
% estimated plane ID, groundTruth planeID; For ground truth planes without
% relationship the IDs are [0 0]

Ne=size(eADD_m,1);
matchID=zeros(Ne,4);
matchID(:,1:2)=planeIDs;

for i=1:Ne
   rowi=eADD_m(i,:);
   indexGTPlane=find(rowi<theta);
   if ~isempty(indexGTPlane)
        matchID(i,3:4)=[gtPlanes(indexGTPlane).idFrame gtPlanes(indexGTPlane).idPlane];
   end
end

end

