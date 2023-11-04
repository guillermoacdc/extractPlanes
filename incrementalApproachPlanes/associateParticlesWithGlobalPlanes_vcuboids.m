function globalPlanes = associateParticlesWithGlobalPlanes_vcuboids(globalPlanes,particlesVector, radiiRef)
%ASSOCIATEPARTICLESWITHGLOBALPLANES_vcuboids Manages the association of particles ids with global
%planes in the field timeParticleID, for each type of plane

globalPlanes_xz = associateParticlesWithGlobalPlanes(globalPlanes.values(globalPlanes.xzIndex),...
    particlesVector.xz, radiiRef.top);

globalPlanes_xy = associateParticlesWithGlobalPlanes(globalPlanes.values(globalPlanes.xyIndex),...
    particlesVector.xy, radiiRef.perpendicular);

globalPlanes_zy = associateParticlesWithGlobalPlanes(globalPlanes.values(globalPlanes.zyIndex),...
    particlesVector.zy, radiiRef.perpendicular);
% validar si esta linea es necesaria; en teoria no, puesto que las
% funciones anteriores asumen paso por referencia para la variable
% globalPlanes
globalPlanes.values=[globalPlanes_xz, globalPlanes_xy,globalPlanes_zy];

end

