function [pcBox,planeDescriptor] = createSyntehticPCFromDetectedBox(boxDescriptor,sessionID,...
    NpointsDiagPpal, gridStep)
%CREATESYNTEHTICPCFROMDETECTEDBOX Creates a point cloud from descriptors a
%detected box ID

W=boxDescriptor.width;
D=boxDescriptor.depth;
planeDescriptor=convertBoxIntoPlaneObject(boxDescriptor, sessionID);
pcBox=createSyntheticPCFromDetection(planeDescriptor, NpointsDiagPpal, gridStep,...
    W,D);
end

