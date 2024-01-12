function [globalPlanes, particlesVector] =updatePresence_v3(globalPlanes,particlesVector,windowInit,...
    firstKeyFrame, th_vigency)
%UPDATEPRESENCE 
% 1 computes (a) particles out of the window, (b) particles 
% without relationships
% 2 detect indexes related with previous particles
% 3 deletes the planes associated with those indexes

NgpInit=size(globalPlanes,2);
% find particles out of window
Npv=size(particlesVector,2);

%% computing index of particles out of the window
outOfTimeParticleIndex=[];
% windowInit=frameID-windowSize;
if windowInit<1
    windowInit=firstKeyFrame;
end
for i=1:Npv
    particle=particlesVector(i);
    meanDetections=computeMeanDetections(particle,windowInit);
    if meanDetections<th_vigency
        outOfTimeParticleIndex=[outOfTimeParticleIndex i];
    end
end

%% compute id of particles without relationship
% compute foreign keys (timeParticleID) in global planes fkIDs
fkIDs=getTimeParticleID(globalPlanes);
% compute vector of ids in particle vectors IDs
IDs=getParticlesID(particlesVector);
% compute particle wout relationship by selecting fkIDs that do not belong to IDs
outOfRelationParticles_IDs=setdiff(IDs,fkIDs)';
% compute ID of out of time particles
outOfTimeParticle_IDs=getParticlesID(particlesVector(outOfTimeParticleIndex));
% join IDs and compute unique version
outParticles_IDs=[outOfRelationParticles_IDs outOfTimeParticle_IDs'];
outParticles_IDs=unique(outParticles_IDs);
% find indexes of global Planes related with outliers
outliersIndex=computeIndexFromParticleID(globalPlanes,outParticles_IDs );
% delete outliers from global planes
%   condition the elimination to planes without couple

% % Restrict the elimination of planes to those that do not have idBox
% NoutIndex=length(outliersIndex);
% indexToExtract=[];
% for k=1:NoutIndex
%     if ~isempty(globalPlanes(outliersIndex(k)).idBox)
%         indexToExtract=[indexToExtract k];
% %      break the relation with box - penalization 
%     globalPlanes(outliersIndex(k)).idBox=[];
%     end
% end
% outliersIndex(indexToExtract)=[];

globalPlanes(outliersIndex)=[];

NgpEnd=size(globalPlanes,2);
NpvInit=size(particlesVector,2);
forgotenParticles=NpvInit-length(outParticles_IDs);
% find indexes of particles vector related with outliers
outParticles_index=getParticlesIndexFromID(particlesVector, outParticles_IDs);
% delete particles outOfTimeParticleIndex and outOfRelationParticles_IDs
particlesVector(outParticles_index)=[];
disp('---------------')
disp([num2str(NgpInit-NgpEnd) ' planes of ' num2str(NgpInit) ' have been forgotten during window update'])
disp(['particles forgotten: ' num2str(forgotenParticles) '/' num2str(NpvInit)])
disp('---------------')
end

