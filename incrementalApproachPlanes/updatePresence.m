function [globalPlanes, particlesVector] =updatePresence(globalPlanes,particlesVector,windowSize,...
    frameID, firstKeyFrame)
%UPDATEPRESENCE computes particles out of the window, detect indexes related
%with those particles and deletes the planes associated with those indexes
NgpInit=size(globalPlanes,2);
% find particles out of window
Npv=size(particlesVector,2);
outOfTimeParticleID=[];
windowInit=frameID-windowSize;
if windowInit<1
    windowInit=firstKeyFrame;
end


for i=1:Npv
    particle=particlesVector(i);
    meanDetections=computeMeanDetections(particle,windowInit);
    if meanDetections<0.1
%     if meanDetections==0
        outOfTimeParticleID=[outOfTimeParticleID i];
    end
end
% delete globalPlanes without timeParticleID property
% idnull=extractIDWithNullTimeParticle(globalPlanes);
% if ~isempty(idnull)
%     globalPlanes(idnull)=[];
% end

% find indexes related with outliers
outliersID=computeIndexFromParticleID(globalPlanes,outOfTimeParticleID);

% delete outliers from global planes
globalPlanes(outliersID)=[];
NgpEnd=size(globalPlanes,2);
% delete particles outOfTimeParticleID
particlesVector(outOfTimeParticleID)=[];

disp([num2str(NgpInit-NgpEnd) ' planes of ' num2str(NgpInit) ' have been forgotten'])
end

