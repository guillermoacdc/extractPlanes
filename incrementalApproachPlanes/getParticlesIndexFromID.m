function particlesIndex = getParticlesIndexFromID(particlesVector, outParticles_IDs)
%GETPARTICLESINDEXFROMID Summary of this function goes here
%   Detailed explanation goes here
% assumptions: outParticles_IDs doesnt have repeated elements
particlesIndex=[];
Nids=length(outParticles_IDs);
Npv=size(particlesVector,2);
for i=1:Nids
    partID=outParticles_IDs(i);
    match=false;
    j=1;
    while j<=Npv | ~match
        if partID==particlesVector(j).id
            particlesIndex=[particlesIndex j];
            match=true;
        end
        j=j+1;
    end
end


end

