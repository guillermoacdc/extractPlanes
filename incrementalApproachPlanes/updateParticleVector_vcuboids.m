function [particlesVector, localPlanes] = updateParticleVector_vcuboids(localPlanes,particlesVector, radii, frameID)
%UPDATEPARTICLESVECTOR_vcuboid. Gestiona la actualización del vector de
%partículas en sus tres versiones 

particlesVector_xz = updateParticleVector(localPlanes.values(localPlanes.xzIndex), ...
    particlesVector.xz, radii.top, frameID);

particlesVector_xy = updateParticleVector(localPlanes.values(localPlanes.xyIndex), ...
    particlesVector.xy, radii.perpendicular, frameID);

particlesVector_zy = updateParticleVector(localPlanes.values(localPlanes.zyIndex), ...
    particlesVector.zy, radii.perpendicular, frameID);

particlesVector.xz=particlesVector_xz;
particlesVector.xy=particlesVector_xy;
particlesVector.zy=particlesVector_zy;

