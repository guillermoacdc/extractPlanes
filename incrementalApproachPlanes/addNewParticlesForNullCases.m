function [particlesVector, localPlanes]=addNewParticlesForNullCases(localPlanes,particlesVector,matchM, frameID)
%ADDNEWPARTICLESFORNULLCASES Summary of this function goes here
%   Detailed explanation goes here
% update foreignKey in localPlanes -- evaluar si es necesario
Nlp=size(matchM,1);
    for i=1:Nlp
        indexpv=find(matchM(i,:)==true);
        if ~isempty(indexpv)
            localPlanes(i).timeParticleID=particlesVector(indexpv).id;
        end
    end
% create new particle for local planes with null relationship with
% particles
    nullIDs=extractIDWithNullTimeParticle(localPlanes);
    if ~isempty(nullIDs)
        Nnid=length(nullIDs);
        for i=1:Nnid
%                 Npv_dinamic=size(particlesVector,2);
                 Npv_dinamic=computeMaxIDParticle(particlesVector);   
    %             creación de la nueva partícula
                particlesVector(end+1)=particle(Npv_dinamic+1, localPlanes(nullIDs(i)).geometricCenter,...
                    localPlanes(nullIDs(i)).fitness,frameID);
    %             adición de llave foránea en plano local
                localPlanes(nullIDs(i)).timeParticleID=Npv_dinamic+1;
        end
    end
end

