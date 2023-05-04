function [bufferCP] = updateIDofComponents_v2(planeDescriptor, bufferCP, maxComp)
%UPDATEIDOFCOMPONENTS Summary of this function goes here
%   Detailed explanation goes here
idFrame=planeDescriptor.idFrame;
idPlane=planeDescriptor.idPlane;

components=getComponentsMergedPlanes(idFrame,idPlane,bufferCP);

Ncomp=size(components,1);
for i=1:Ncomp
    index=extractIndexFromIDs(bufferCP,components(i,1),components(i,2));
    bufferCP(index).composed_idFrame=0;
    bufferCP(index).composed_idPlane=maxComp+1;
end
% update id on the original container
planeDescriptor.idFrame=0;
planeDescriptor.idPlane=maxComp+1; 
end

