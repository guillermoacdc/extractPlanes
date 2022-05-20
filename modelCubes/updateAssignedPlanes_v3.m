function [assignedPlanes unassignedPlanes] = updateAssignedPlanes_v3(myPlanes)
%UPDATEASSIGNEDPLANES Summary of this function goes here
%   Detailed explanation goes here

fields = fieldnames( myPlanes );
N1=size(fields,1);
assignedPlanes=[];
unassignedPlanes=[];
for i=1:N1
    N2=size(myPlanes.(fields{i}),2);
    for j=1:N2
        if ~isempty(myPlanes.(fields{i})(j).secondPlaneID) & ~isempty(myPlanes.(fields{i})(j).thirdPlaneID)
            assignedPlanes=[assignedPlanes; myPlanes.(fields{i})(j).getID];
        else
            unassignedPlanes=[unassignedPlanes; myPlanes.(fields{i})(j).getID];
        end
%         all_IDs=[all_IDs; myPlanes.(fields{i})(j).getID];
    end
end

end

% all_IDs=setdiff_v2(all_IDs,globalRejectedPlanes);


%     assignedPlanes=[];
%     unassignedPlanes=[];
%     for i1=1:size(myPlanes,2)
%         if ~isempty(myPlanes(i1).secondPlaneID) & ~isempty(myPlanes(i1).thirdPlaneID)
%             assignedPlanes=[assignedPlanes; myPlanes(i1).getID];
%         else
%             unassignedPlanes=[unassignedPlanes; myPlanes(i1).getID];
%         end
%     end
% end

