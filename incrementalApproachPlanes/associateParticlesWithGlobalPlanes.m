function globalPlanes = associateParticlesWithGlobalPlanes(globalPlanes,particlesVector, radiiRef)
%ASSOCIATEPARTICLESWITHGLOBALPLANES Associates particle ids with global
%planes in the field timeParticleID
Ngp=size(globalPlanes,2);
Npv=size(particlesVector,2);

if Npv>0
    for i =1:Ngp
        matchFlag=false;
        globalPlane=globalPlanes(i);
%         if globalPlane.type==0
%             radii=radiiRef.top;
%         else
%             radii=radiiRef.perpendicular;
%         end
        j=1;
        while j<=Npv & matchFlag==false
            particleInst=particlesVector(j);
%             assess particle match and save
            matchFlag=(norm(globalPlane.geometricCenter-particleInst.position)<=radiiRef);
%             matchM(i,j)=matchFlag;
            j=j+1;
        end

        if matchFlag & isempty(globalPlane.timeParticleID)
            globalPlane.timeParticleID=particleInst.id;
        end
    end
    
end

end

