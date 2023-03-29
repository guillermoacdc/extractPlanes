function matchID=compare_eADDvsTheta(eADD_m,theta,planeIDs,pps)
%COMPARE_EADDVSTHETA Summary of this function goes here
%   matchID contains relationship between estimated planeID and boxID for a
%   single frame

Ne=size(eADD_m,1);
matchID=zeros(Ne,2);
matchID(:,1)=planeIDs;

for i=1:Ne
   rowi=eADD_m(i,:);
   indexBoxID=find(rowi<theta);
   if ~isempty(indexBoxID)
        matchID(i,2)=pps(indexBoxID);
   end
end

end

