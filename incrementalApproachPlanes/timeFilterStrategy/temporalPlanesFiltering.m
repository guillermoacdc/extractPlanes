function [globalPlanes,particlesVector] = temporalPlanesFiltering(globalPlanes,particlesVector, radii, frameID, windowSize)
%TEMPORALPLANESFILTERING Summary of this function goes here
%   Detailed explanation goes here


Ngp=size(globalPlanes,2);
Npv=size(particlesVector,2);
%% initialization
if Npv>0
    for i =1:Ngp
        matchFlag=0;
        globalPlane=globalPlanes(i);
        j=1;
        while j<Npv & match==false
            particle=particlesVector(j);
            matchFlag=(norm(globalPlane-particle)>=radii);

            if matchFlag
                particle.myPush(frameID,1);
                globalPlane.timeParticleID=particle.id;
            else
                particle.myPush(frameID,0);
            end
            j=j+1;
        end

        if ~matchFlag
            Npv_dinamic=size(particlesVector,2);
            particlesVector(end+1)=particle(Npv_dinamic+1, globalPlane.geometricCenter,...
                globalPlane.numberInliers,globalPlane.distanceToCamera,frameID);
        end
    end
    globalPlanes=updatePresence(globalPlanes,particleVector,windowSize);
else
    for i=1:Ngp
        pos_ref=globalPlanes(i).geometricCenter;
        Ninliers_ref=globalPlanes(i).numberInliers;
        dco_ref=globalPlanes(i).distanceToCamera;%validate units
        particlesVector(i)=particle(i,pos_ref,Ninliers_ref,dco_ref, frameID);
    end
end   

end

