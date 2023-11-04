function [planeDescriptor] = convertBoxIntoPlaneObject(boxObject, sessionID)
%GENERATESYNTHETICPC Generates a planeDescriptor for a single box with a 
% predefined number of sides in sidesVector

% sidesVector codes
% 1 top plane
% 2 front plane
% 3 right plane
% 4 back plane
% 5 left plane
Nsides=length(boxObject.sidesID);
planeDescriptor=[];
Th2b = boxObject.tform;

dataSetPath=[];
for i=1:Nsides
    planeGroup=boxObject.sidesID(i);
    planeDTemp=computePlaneDescriptorsFromDetectedBox(boxObject,sessionID,...
        dataSetPath,planeGroup);
    planeDTemp.tform=Th2b*planeDTemp.tform;
    planeDTemp.idFrame=planeDTemp.idBox;
    planeDTemp.idPlane=planeGroup;%----i
    newgc=Th2b*[planeDTemp.geometricCenter'; 1];
    planeDTemp.geometricCenter=newgc(1:3);
    planeDescriptor=[planeDescriptor planeDTemp];
end


end

