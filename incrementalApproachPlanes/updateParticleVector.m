function [particlesVector, localPlanes] = updateParticleVector(localPlanes,particlesVector, radii, frameID)
%UPDATEPARTICLESVECTOR. Cada vez que se crea un mapa de planos locales 〖lp〗_s (k), 
% se evalúa la ecuación (5) entre los segmentos de plano 〖ps〗_i∈〖lp〗_s (k)  
% y los elementos del vector de partículas PT. Posteriormente, se ejecutan
% las siguientes actualizaciones:

% 	Para todo segmento de plano 〖ps〗_i que cumpla la ecuación (5) 
%   con una partícula 〖pt〗_j∈PT, se inicia el proceso de actualización 
%   de propiedades de la partícula 〖pt〗_j utilizando las ecuaciones (6), (7); 
%   en donde, w_1, w_2 son pesos calculados a partir del fitness de la 
%   partícula 〖pt〗_j y el segmento de plano 〖ps〗_i, respectivamente (w_1+w_2=1). 
%   En caso de cumplimiento con múltiples partículas, solo se actualizan 
%   las propiedades de la partícula que esté a menor distancia del segmento 
%   de plano . 

% 	Para todo segmento de plano 〖ps〗_i que no cumpla la ecuación (5) 
%   con al menos una partícula del vector PT, se inicia el proceso de
%   adición de nueva partícula al vector PT. Esta nueva partícula va a 
%   tener los descriptores de posición y fitness pertenecientes a 
%   〖ps〗_i. El vector de vigencia será inicializado con los valores 
%   [k verdadero]. 

% 	Para partículas 〖pt〗_j que no tengan relación con ninguno de los
%   segmentos de plano 〖ps〗_i, se adiciona un nuevo elemento al final
%   del vector de vigencia con valor [k false];  


Nlp=size(localPlanes,2);
Npv=size(particlesVector,2);
% matchM=myBoolean(zeros(Nlp,Npv));%how to declare as boolean?

if Npv>0
    %compute matchM matrix
    matchM=compareParticlesvsLocalPlanes(localPlanes,particlesVector,radii);
    % refiante matchM matrix
    matchM=refinateMatchM(localPlanes,particlesVector,matchM);
    % update particle properties
    particlesVector=updateParticleProperties(localPlanes,particlesVector,matchM,frameID);
    %add new particles for unmatch local planes
    particlesVector=addNewParticles(localPlanes,particlesVector,matchM, frameID);
    % create new particle for local planes with null relationship with
    % particles
    [particlesVector, localPlanes]=addNewParticlesForNullCases(localPlanes,particlesVector,matchM, frameID);
else %initialization of particle vector
    for i=1:Nlp
        pos_ref=localPlanes(i).geometricCenter;
        fitness_ref=localPlanes(i).fitness;
        myParticle=particle(i,pos_ref,fitness_ref, frameID);%particle is the constructor of the class with the same name
        particlesVector(i)=myParticle;
    end
end   

end

% Identifica planos locales que estén en la
%vecindad de una partícula. En caso de identificación nula, crea una nueva
%partícula con la posisción del plano no identificado. 
% _v2: corrije el problema de múltiples planos locales apuntando a una
% misma partícula. Se selecciona el plano local con menor distancia a la
% partícula
%   Detailed explanation goes here