function [assignedPlanes unassignedPlanes]= cuboidDetectionv2_v2(myPlanes, th_angle, unassignedPlanes, frame, assignedPlanes )
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
        cuboidDetection_naivy_v2(myPlanes, th_angle, unassignedPlanes);
else
        %perform pair cuboid detection between assigned and unassigned planes
        cuboidDetection_pair_v2(myPlanes, th_angle, unassignedPlanes, assignedPlanes)
end

unassignedPlanes=[];
% compute assigned planes for the current frame
[assignedPlanes unassignedPlanes] = updateAssignedPlanes_v2(myPlanes.(['fr' num2str(frame)]));

end
