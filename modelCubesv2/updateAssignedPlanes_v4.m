function [assignedPlanes, unassignedPlanes] = updateAssignedPlanes_v4(globalPlanes)
%UPDATEASSIGNEDPLANES Summary of this function goes here
%   Detailed explanation goes here
% _v4 uses the structure planesDescriptor with the fields (1) camerapose, (2) values

% fields = fieldnames( globalPlanes );
% N1=size(fields,1);
assignedPlanes=[];
unassignedPlanes=[];
% for i=1:N1
    N2=length(globalPlanes);
    for j=1:N2
%         if ~isempty(globalPlanes(j).secondPlaneID) & ~isempty(globalPlanes(j).thirdPlaneID)
        if ~isempty(globalPlanes(j).secondPlaneID)
            assignedPlanes=[assignedPlanes; globalPlanes(j).getID];
        else
            unassignedPlanes=[unassignedPlanes; globalPlanes(j).getID];
        end
    end
% end

end



