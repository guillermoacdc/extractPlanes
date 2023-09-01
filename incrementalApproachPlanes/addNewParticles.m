function particlesVector = addNewParticles(localPlanes,...
    particlesVector,matchM,frameID)
%ADDNEWPARTICLES Adiciona partículas al vector particlesVector para los
%casos de planos locales que no tienen match
%   Detailed explanation goes here

Nlp=size(matchM,1);
for i=1:Nlp
    flagInRow=myORvector(matchM(i,:));
    if ~flagInRow
        Npv=computeMaxIDParticle(particlesVector);
%         Npv=length(particlesVector);
        % creación de la nueva partícula
        particlesVector(end+1)=particle(Npv+1, localPlanes(i).geometricCenter,...
        localPlanes(i).fitness,frameID);
    %opcional. adición de llave foránea en plano local
%         localPlanes(i).timeParticleID=Npv+1;
    end
end

end

