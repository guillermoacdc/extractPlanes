function [idComponents] = getComponentsMergedPlanes(idFrame, idPlane, buffer)
%GETCOMPONENTSMERGEDPLANES Recover the components of a composed plane with
%ids idFrame, idPlane
%   Detailed explanation goes here
idComponents=[];
N=size(buffer,2);
k=1;
for i=1:N
    if idFrame==buffer(i).composed_idFrame & idPlane==buffer(i).composed_idPlane
        idComponents(k,1)=buffer(i).idFrame;
        idComponents(k,2)=buffer(i).idPlane;
        k=k+1;
    end
end

if isempty(idComponents)
    disp('stop mark from getComponentsMegedPlanes')
end

end

