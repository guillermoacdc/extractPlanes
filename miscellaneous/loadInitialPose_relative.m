function planeDescriptors_rel = loadInitialPose_relative(sessionID, frameID,planesGroup)
%LOADINITIALPOSE_RELATIVE Summary of this function goes here
%   Detailed explanation goes here
dataSetPath=computeMainPaths(sessionID);
planeDescriptors_m=loadInitialPose_v3(dataSetPath, sessionID, frameID, planesGroup);
planeDescriptors_rel =planeDescriptors_m;
[~,~,boxID]=getTargetFramesFromScene(sessionID);
Tm2ref=loadInitialPoseByBox(boxID,sessionID,1);% no se usa el tercer argumento; no intersa que la caja haya salido de la zona de consolidación, aún así sigue siendo la referencia
Tref2m=inv(Tm2ref);

Nb=size(planeDescriptors_m,2);
for i=1:Nb
    planeDescriptors_rel(i).tform=planeDescriptors_m(i).tform*Tref2m; 
end

end

