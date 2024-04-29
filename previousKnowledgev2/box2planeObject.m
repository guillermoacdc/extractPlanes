function [planeDescriptor] = box2planeObject(myBox)
%BOX2PLANEOBJECT Converts a box object into a set of plane objects arranged
%in a vector with name planeDescriptor

% sidesVector codes -- updated to match with developments in box tracking
% 0 top plane
% 2 front plane
% 1 right plane
% 4 back plane
% 3 left plane
Nsides=length(myBox.sidesID);
planeDescriptor=[];

Tm2b = myBox.tform;%
% Tm2b(1:3,1:3)=rotx(-90)*myBox.tform(1:3,1:3);
for i=1:Nsides
    sideID=myBox.sidesID(i);
    planeDTemp=computeSinglePlaneFromBox(myBox,sideID);
    planeDTemp.tform=Tm2b*planeDTemp.tform;
    planeDTemp.idFrame=myBox.id;
%     planeDTemp.idPlane=[];%----i
    newgc=Tm2b*[planeDTemp.geometricCenter'; 1];
    planeDTemp.geometricCenter=newgc(1:3);
%     set l2ToY for perpendicular planes
    if sideID~=0
        planeDTemp.type=1;
        if planeDTemp.L2==myBox.height
            planeDTemp.L2toY=true;
        else
            planeDTemp.L2toY=false;
        end
    else
        planeDTemp.type=0;
    end
    planeDescriptor=[planeDescriptor planeDTemp];
end


end

