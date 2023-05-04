function meanDetections=computeMeanDetections(particle,windowInit)
%COMPUTEMEANDETECTIONS Summary of this function goes here
%   Detailed explanation goes here
initIdx=find(particle.historicPresence(:,1)==windowInit);
if isempty(initIdx)
    meanDetections=0;
else
    meanDetections=mean(particle.historicPresence(initIdx:end,2));
end


end

