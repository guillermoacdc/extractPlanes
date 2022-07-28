function [assignedPlanes unassignedPlanes] = updateAssignedPlanes_v4(myPlanes)
%UPDATEASSIGNEDPLANES Summary of this function goes here
%   Detailed explanation goes here
% _v4 uses the structure planesDescriptor with the fields (1) camerapose, (2) values

fields = fieldnames( myPlanes );
N1=size(fields,1);
assignedPlanes=[];
unassignedPlanes=[];
for i=1:N1
    N2=size(myPlanes.(fields{i}).values,2);
    for j=1:N2
        if ~isempty(myPlanes.(fields{i}).values(j).secondPlaneID) & ~isempty(myPlanes.(fields{i}).values(j).thirdPlaneID)
            assignedPlanes=[assignedPlanes; myPlanes.(fields{i}).values(j).getID];
        else
            unassignedPlanes=[unassignedPlanes; myPlanes.(fields{i}).values(j).getID];
        end
    end
end

end



