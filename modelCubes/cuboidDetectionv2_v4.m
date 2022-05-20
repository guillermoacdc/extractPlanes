function assignedPlanes= cuboidDetectionv2_v4(conditionalAssignationFlag,...
    myPlanes, th_angle, unassignedPlanes, assignedPlanes)
%CUBOIDDETECTION Performs cuboid Detection as described in [1]
%   Detailed explanation goes here
% [1] file:///G:/Mi%20unidad/semestre%206/1-3%20AlgoritmosSeguimientoPose/detectorCajas/Incremental-3D-cuboid-modeling-with-drift-compensationSensors-Switzerland.pdf

% _v2 is the identifier for the two dimensional version in the index of the
% planes. each index has the form [v1 v2], where v1 is the frame id and v2
% is the plane id
if nargin==4
    %perform naivy cuboid detection between unassigned planes
    assignedPlanes=[];
end

if(isempty(assignedPlanes))
        %perform naivy cuboid detection between unassigned planes
%         cuboidDetection_naivy_v3(myPlanes, th_angle, unassignedPlanes);
        cuboidDetection_naivy_v4(myPlanes, th_angle, unassignedPlanes, conditionalAssignationFlag);
else
        %perform pair cuboid detection between assigned and unassigned planes
        cuboidDetection_pair_v4(myPlanes, th_angle, unassignedPlanes, assignedPlanes, conditionalAssignationFlag)
end

% compute assigned planes for all planes
assignedPlanes  = updateAssignedPlanes_v3(myPlanes);

end
