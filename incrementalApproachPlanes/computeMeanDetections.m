function meanDetections=computeMeanDetections(particle,windowInit)
%COMPUTEMEANDETECTIONS Summary of this function goes here
%   Detailed explanation goes here
initIdx=find(particle.historicPresence(:,1)>windowInit);

if isempty(initIdx)
    meanDetections=0;
else
    initIdx=initIdx(1);
    meanDetections=mean(particle.historicPresence(initIdx:end,2));
%     meanDetections=mean(particle.historicPresence(:,2));
end


end

