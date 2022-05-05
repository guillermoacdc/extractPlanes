function [assignedPlanes unassignedPlanes] = updateAssignedPlanes_v2(myPlanes)
%UPDATEASSIGNEDPLANES Summary of this function goes here
%   Detailed explanation goes here
    assignedPlanes=[];
    unassignedPlanes=[];
    for i1=1:size(myPlanes,2)
        if ~isempty(myPlanes(i1).secondPlaneID) & ~isempty(myPlanes(i1).thirdPlaneID)
            assignedPlanes=[assignedPlanes; myPlanes(i1).getID];
        else
            unassignedPlanes=[unassignedPlanes; myPlanes(i1).getID];
        end
    end
end

