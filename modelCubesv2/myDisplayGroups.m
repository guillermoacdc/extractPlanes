function myDisplayGroups(globalPlanes, group_tpp, group_tp, group_s)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% disp single associations
disp('single groups---')
Np=length(group_s);
for i=1:Np
    plane=globalPlanes(group_s(i));
    disp(['          plane ' num2str(plane.idFrame) '-' num2str(plane.idPlane)])
end
% disp dual associations
disp('couples---')
Np=length(group_tp);
for i=1:Np
    plane=globalPlanes(group_tp(i));
    secondIndex=plane.secondPlaneID;
    pairs=[plane.getID(), globalPlanes(secondIndex).getID];
    disp(['          plane ' num2str(pairs(1)) '-' num2str(pairs(2))...
        ' is associated with plane ' num2str(pairs(3)) '-' num2str(pairs(4))])
end
% disp triads
disp('triads---')
Np=length(group_tpp);
for i=1:Np
    plane=globalPlanes(group_tpp(i));
    secondIndex=plane.secondPlaneID;
    thirdIndex=plane.thirdPlaneID;
    pairs=[plane.getID(), globalPlanes(secondIndex).getID, globalPlanes(thirdIndex).getID];
    disp(['          plane ' num2str(pairs(1)) '-' num2str(pairs(2))...
        ' is associated with plane ' num2str(pairs(3)) '-' num2str(pairs(4)),...
        ' and plane ' num2str(pairs(5)) '-' num2str(pairs(6))])
end



end

