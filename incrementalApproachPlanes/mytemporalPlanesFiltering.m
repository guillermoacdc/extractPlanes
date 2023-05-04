function [globalPlanes,particlesVector] = mytemporalPlanesFiltering(globalPlanes,particlesVector, radii, frameID, windowSize)
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
            particleInst=particlesVector(j);
            matchFlag=(norm(globalPlane-particleInst)>=radii);

            if matchFlag
                particleInst.myPush(frameID,1);
                globalPlane.timeParticleID=particleInst.id;
            else
                particleInst.myPush(frameID,0);
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
        myParticle=particle(i,pos_ref,Ninliers_ref,dco_ref, frameID);%particle is the constructor of the class with the same name
        particlesVector(i)=myParticle;
    end
end   

end

