function globalPlanes=updatePresence(globalPlanes,particleVector,windowSize, frameID, th_detections)
%UPDATEPRESENCE computes particles out of the window, detect indexes related
%with those particles and deletes the planes associated with those indexes

% find particles out of window
Npv=size(particleVector,2);
outOfTimeParticleID=[];
windowInit=frameID-windowSize;
for i=1:Npv
    particle=particleVector(i);
    meanDetections=computeMeanDetections(particle,windowInit);
    if meanDetections<th_detections
        outOfTimeParticleID=[outOfTimeParticleID i];
    end
end

% find indexes related with outliers
outliersID=computeIndexFromParticleID(globalPlanes,outOfTimeParticleID);

% delete outliers from global planes
globalPlanes(outliersID)=[];

end

