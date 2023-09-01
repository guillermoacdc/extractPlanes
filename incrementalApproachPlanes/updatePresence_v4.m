function [globalPlanes, particlesVector] =updatePresence_v4(globalPlanes,particlesVector,windowInit,...
    firstKeyFrame, th_vigency)
%UPDATEPRESENCE computes particles out of the window, detect indexes related
%with those particles and deletes the planes associated with those indexes
% _v4 restringe la deteccion de partículas no vigentes a un máximo de 1 por
% iteración: aquella con el menor promedio de vigencias
NgpInit=size(globalPlanes,2);
% find particles out of window
Npv=size(particlesVector,2);
outOfTimeParticleID=[];
% windowInit=frameID-windowSize;
if windowInit<1
    windowInit=firstKeyFrame;
end

meanDetections=zeros(1,Npv);
for i=1:Npv
    particle=particlesVector(i);
    meanDetections(i)=computeMeanDetections(particle,windowInit);
end

[~,index_outOfTimeParticleID]=min(meanDetections);
if meanDetections(index_outOfTimeParticleID)<th_vigency
    outOfTimeParticleID=index_outOfTimeParticleID;
end

% find indexes related with outliers
outliersID=computeIndexFromParticleID(globalPlanes,outOfTimeParticleID);

% delete outliers from global planes
globalPlanes(outliersID)=[];
NgpEnd=size(globalPlanes,2);
% delete particles outOfTimeParticleID
particlesVector(outOfTimeParticleID)=[];

disp([num2str(NgpInit-NgpEnd) ' planes of ' num2str(NgpInit) ' have been forgotten'])
end

