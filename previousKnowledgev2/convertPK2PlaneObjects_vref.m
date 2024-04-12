function [planeDescriptor] = convertPK2PlaneObjects_vref(boxID,sessionID, ...
    sidesVector, boxLengths)
%GENERATESYNTHETICPC Generates a planeDescriptor for a single box with a 
% predefined number of sides in sidesVector

% sidesVector codes
% 1 top plane
% 2 front plane
% 3 right plane
% 4 back plane
% 5 left plane
Nsides=size(sidesVector,2);
planeDescriptor=[];
% dataSetPath=computeMainPaths(sessionID);
% dataSetPath = computeReadPaths(sessionID);
Tm2b = eye(4);
for i=1:Nsides
    planeGroup=sidesVector(i);
    planeDTemp=computePlaneDescriptorsFromBoxID_vref(boxID,sessionID, boxLengths,planeGroup);
    planeDTemp.tform=Tm2b*planeDTemp.tform;
    planeDTemp.idFrame=planeDTemp.idBox;
    planeDTemp.idPlane=planeGroup;%----i
    newgc=Tm2b*[planeDTemp.geometricCenter'; 1];
    planeDTemp.geometricCenter=newgc(1:3);
    planeDescriptor=[planeDescriptor planeDTemp];
end


end

