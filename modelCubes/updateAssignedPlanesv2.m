function [assignedPlanes unassignedPlanes] = updateAssignedPlanesv2(setOfPlanes)
%UPDATEASSIGNEDPLANES Summary of this function goes here
%   Detailed explanation goes here
    assignedPlanes=[];
    unassignedPlanes=[];
    for i1=1:size(setOfPlanes,2)
        if ~isempty(setOfPlanes{i1}.secondPlaneID) & ~isempty(setOfPlanes{i1}.thirdPlaneID)
            assignedPlanes=[assignedPlanes; setOfPlanes{i1}.getID];
        else
            unassignedPlanes=[unassignedPlanes; setOfPlanes{i1}.getID];
        end
    end
end

