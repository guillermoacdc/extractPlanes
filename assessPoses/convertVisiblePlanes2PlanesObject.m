function planeDescriptorGTV = convertVisiblePlanes2PlanesObject(visiblePlanesByFrame, ...
    sessionID, frameID)
%CONVERTVISIBLEPLANES2PLANESOBJECT Summary of this function goes here
%   Detailed explanation goes here
Nb=size(visiblePlanesByFrame,1);
planeDescriptorGTV=[];
for i=1:Nb
    boxID=visiblePlanesByFrame(i).boxID;
    sidesVector=visiblePlanesByFrame(i).planesID';
    planeDescriptor_temp=convertPK2PlaneObjects_v5(boxID, sessionID, sidesVector, frameID);
    planeDescriptorGTV=[planeDescriptorGTV, planeDescriptor_temp];
end
end

