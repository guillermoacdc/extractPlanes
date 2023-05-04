function outliersID=computeIndexFromParticleID(globalPlanes,outOfTimeParticleID)
%COMPUTEINDEXFROMPARTICLEID Summary of this function goes here
%   Detailed explanation goes here

Ngp=size(globalPlanes,2);
outliersID=[];
for i=1:Ngp
    matchVector=globalPlanes(i).timeParticleID==outOfTimeParticleID;
    match=find(matchVector==true);
    if match
        outliersID=[outliersID globalPlanes(i).idPlane];
    end
end

end

