function [particlesVector, localPlanes] = computeParticlesVector_v2(localPlanes,particlesVector, radii, frameID)
%TEMPORALPLANESFILTERING Identifica planos locales que estén en la
%vecindad de una partícula. En caso de identificación nula, crea una nueva
%partícula con la posisción del plano no identificado. 
% _v2: corrije el problema de múltiples planos locales apuntando a una
% misma partícula. Se selecciona el plano local con menor distancia a la
% partícula
%   Detailed explanation goes here


Nlp=size(localPlanes,2);
Npv=size(particlesVector,2);
matchM=myBoolean(zeros(Nlp,Npv));%how to declare as boolean?
%% initialization
if Npv>0
    for i =1:Nlp
        matchFlag=false;
        globalPlane=localPlanes(i);
        j=1;
        while j<=Npv & matchFlag==false
            particleInst=particlesVector(j);
%             assess particle match and save
            matchFlag=(norm(globalPlane.geometricCenter-particleInst.position)<=radii);
            matchM(i,j)=matchFlag;
            j=j+1;
        end

        if ~matchFlag
            Npv_dinamic=size(particlesVector,2);
%             creación de la nueva partícula
            particlesVector(end+1)=particle(Npv_dinamic+1, globalPlane.geometricCenter,...
                globalPlane.fitness,frameID);
%             adición de llave foránea en plano local
            localPlanes(i).timeParticleID=Npv_dinamic+1;
        end
    end
% update matchFlag to avoid multiple local planes pointing to a single
% particle

for i=1:Npv
%     validate if there are multiple local planes pointing to a single
%     particle
    rows=find(matchM(:,i)==true);
    Nr=size(rows,1);
    if Nr>1
        distances=zeros(Nr,1);
        for j=1:Nr
            distances(j)=norm(localPlanes(rows(j)).geometricCenter-particlesVector(i).position);
        end
        [~,index]=min(distances);
        matchM(:,i)=myBoolean(zeros(Nlp,1));
        matchM(index,i)=true;        
    end
end

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
%           fitness=(particle.fitness+localPlane.fitness)/2
        end
    end
% update foreignKey in localPlanes -- evaluar si es necesario
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
                Npv_dinamic=size(particlesVector,2);
    %             creación de la nueva partícula
                particlesVector(end+1)=particle(Npv_dinamic+1, localPlanes(nullIDs(i)).geometricCenter,...
                    localPlanes(nullIDs(i)).fitness,frameID);
    %             adición de llave foránea en plano local
                localPlanes(nullIDs(i)).timeParticleID=Npv_dinamic+1;
        end
    end
else
    for i=1:Nlp
        pos_ref=localPlanes(i).geometricCenter;
        fitness_ref=localPlanes(i).fitness;
        myParticle=particle(i,pos_ref,fitness_ref, frameID);%particle is the constructor of the class with the same name
        particlesVector(i)=myParticle;
    end
end   

end

