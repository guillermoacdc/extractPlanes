function [assignedPlanes unassignedPlanes] = updateAssignedPlanes(myPlanes)
%UPDATEASSIGNEDPLANES Summary of this function goes here
%   Detailed explanation goes here
    assignedPlanes=[];
    unassignedPlanes=[];
    for i1=1:size(myPlanes,2)
        if ~isempty(myPlanes{i1}.secondPlaneID) & ~isempty(myPlanes{i1}.thirdPlaneID)
            assignedPlanes=[assignedPlanes i1];
        else
            unassignedPlanes=[unassignedPlanes i1];
        end
    end
end

