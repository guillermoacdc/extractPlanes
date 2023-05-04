function particlesVector = computeParticlesVector_v2(globalPlanes,particlesVector, radii, frameID)
%TEMPORALPLANESFILTERING Identifica planos globales que estén en la
%vecindad de una partícula. En caso de identificación nula, crea una nueva
%partícula con la posisción del plano no identificado. 
% _v2: corrije el problema de múltiples planos globales apuntando a una
% misma partícula. Se selecciona el plano global con menor distancia a la
% partícula
%   Detailed explanation goes here


Ngp=size(globalPlanes,2);
Npv=size(particlesVector,2);
matchM=myBoolean(zeros(Ngp,Npv));%how to declare as boolean?
%% initialization
if Npv>0
    for i =1:Ngp
        matchFlag=false;
        globalPlane=globalPlanes(i);
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
%             adición de llave foránea en plano global
            globalPlane.timeParticleID=Npv_dinamic+1;
        end
    end
% update matchFlag to avoid multiple global planes pointing to a single
% particle

for i=1:Npv
%     validate if there are multiple global planes pointing to a single
%     particle
    rows=find(matchM(:,i)==true);
    Nr=size(rows,1);
    if Nr>1
        distances=zeros(Nr,1);
        for j=1:Nr
            distances(j)=norm(globalPlanes(rows(j)).geometricCenter-particlesVector(i).position);
        end
        [~,index]=min(distances);
        matchM(:,i)=myBoolean(zeros(Ngp,1));
        matchM(index,i)=true;        
    end
end


% update historicPresence Field and position of the particle
    for i=1:Npv
        flagInColumn=myORvector(matchM(:,i));
        particlesVector(i).myPush(frameID,flagInColumn);
        if flagInColumn
            row=find(matchM(:,i)==true);
            [wg,wp]=computeWeigths(globalPlanes(row).fitness,particlesVector(i).fitness);
            particlesVector(i).position=wg*globalPlanes(row).geometricCenter+...
                wp*particlesVector(i).position;
        end
    end
% update foreignKey in globalPlanes
    for i=1:Ngp
        indexpv=find(matchM(i,:)==true);
        if ~isempty(indexpv)
            globalPlanes(i).timeParticleID=particlesVector(indexpv).id;
        end
    end

else
    for i=1:Ngp
        pos_ref=globalPlanes(i).geometricCenter;
        fitness_ref=globalPlanes(i).fitness;
        myParticle=particle(i,pos_ref,fitness_ref, frameID);%particle is the constructor of the class with the same name
        particlesVector(i)=myParticle;
    end
end   

end

