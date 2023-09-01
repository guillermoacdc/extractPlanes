function particlesVector = updateParticleProperties(localPlanes,particlesVector,matchM, frameID)
%UPDATEPARTICLEPROPERTIES Actualiza las propiedades de las partículas
%   En particulas con match la actualización incluye las propieades
%   fitness, position, vector de vigencia ([frame true]).
% En partículas sin match solo se actualiza el vector vigencia con valores
% [frame false]
Npv=size(matchM,2);
% update historicPresence Field and position of the particle
    for i=1:Npv
        flagInColumn=myORvector(matchM(:,i));
        particlesVector(i).myPush(frameID,flagInColumn);
        if flagInColumn
            row=find(matchM(:,i)==true);
            [wg,wp]=computeWeigths(localPlanes(row).fitness,particlesVector(i).fitness);
            particlesVector(i).position=wg*localPlanes(row).geometricCenter+...
                wp*particlesVector(i).position;
%             actualizar fitness de la partícula en esta línea
          particlesVector(i).fitness=(particlesVector(i).fitness+localPlanes(row).fitness)/2;
        end
    end
end

