function [particlesVector, localPlanes] = updateParticleVector_vcuboid(localPlanes,particlesVector, radii, frameID)
%UPDATEPARTICLESVECTOR_vcuboid. Gestiona la actualización del vector de
%partículas en sus tres versiones 

[particlesVector_xz, localPlanes] = updateParticleVector(localPlanes.values(locaPlanes.xzIndex), ...
    particlesVector.xz, radii, frameID);
% (localPlanes,particlesVector, radii, frameID)
[particlesVector_xy, localPlanes] = updateParticleVector(localPlanes.values(locaPlanes.xyIndex), ...
    particlesVector.xy, radii, frameID);

[particlesVector_zy, localPlanes] = updateParticleVector(localPlanes.values(locaPlanes.zyIndex), ...
    particlesVector.zy, radii, frameID);

particlesVector.xz=particlesVector_xz;
particlesVector.xy=particlesVector_xy;
particlesVector.zy=particlesVector_zy;

