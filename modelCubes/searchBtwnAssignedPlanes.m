function flag = searchBtwnAssignedPlanes(myPlanes,secondPlaneIndex)
%SEARCHBTWNASSIGNEDPLANES search the plane with id secondPlaneIndex between
% the assignedPlanes lists. If exists returns a true, else return a false
%   Detailed explanation goes here
flag=false;

% extract assigned planes
assignedPlanes  = updateAssignedPlanes_v3(myPlanes);
% perform the search
row=myFind2D(secondPlaneIndex,assignedPlanes);
flag= ~isempty(row);

end

