function outliersIndex=computeIndexFromParticleID(globalPlanes,outOfTimeParticleID)
%COMPUTEINDEXFROMPARTICLEID Summary of this function goes here
%   Detailed explanation goes here
% assumptions
% all global planes have value in timeParticleID property
Ngp=size(globalPlanes,2);
outliersIndex=[];
for i=1:Ngp
    matchVector=globalPlanes(i).timeParticleID==outOfTimeParticleID;
    match=find(matchVector==true);
    if match
        outliersIndex=[outliersIndex i];
    end
end

end

