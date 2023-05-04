clc
close all
clear

% globalPlanes=[0.3 0.5 0; 0 0.4 0.5; -0.5 0 0.6; -0.4 -0.5 0; 0 -0.5 0.5; 0.7 0.3 0];
globalPlanes=[0.3 0.5 0];
particle=[0 0 0];
[Idx,D] = rangesearch(globalPlanes,particle,0.65)

myDistance=norm(globalPlanes-particle);


particleVectorPositions=extractPositionsFromParticleVector(particlesVector);
globalGC=globalPlanes(7).geometricCenter;
[Idx,D] = rangesearch(particleVectorPositions,globalGC,65)
