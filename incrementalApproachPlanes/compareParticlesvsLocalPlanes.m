function matchM = compareParticlesvsLocalPlanes(localPlanes,particlesVector,radii)
%COMPAREPARTICLESVSLOCALPLANES evalúa la ecuación (5) entre los segmentos 
% de plano 〖ps〗_i∈〖lp〗_s (k)  y los elementos del vector de partículas PT
%   d(〖ps〗_i.position,〖pt〗_j.position)<radii	(5)

Nlp=size(localPlanes,2);
Npv=size(particlesVector,2);
matchM=myBoolean(zeros(Nlp,Npv));%how to declare as boolean?
 for i =1:Nlp
        matchFlag=false;
        localPlane=localPlanes(i);
        j=1;
        while j<=Npv & matchFlag==false
            particleInst=particlesVector(j);
%             assess particle match and save
            matchFlag=(norm(localPlane.geometricCenter-particleInst.position)<=radii);%equation 5
            matchM(i,j)=matchFlag;
            j=j+1;
        end
end

