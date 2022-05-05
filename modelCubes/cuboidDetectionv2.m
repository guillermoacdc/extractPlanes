function [assignedPlanes unassignedPlanes]= cuboidDetectionv2(myPlanes, th_angle, unassignedPlanes, initIndex, assignedPlanes )
%CUBOIDDETECTION Performs cuboid Detection as described in [1]
%   Detailed explanation goes here
% [1] file:///G:/Mi%20unidad/semestre%206/1-3%20AlgoritmosSeguimientoPose/detectorCajas/Incremental-3D-cuboid-modeling-with-drift-compensationSensors-Switzerland.pdf
if nargin==4
    %perform naivy cuboid detection between unassigned planes
    assignedPlanes=[];
end

if(isempty(assignedPlanes))
        %perform naivy cuboid detection between unassigned planes
        cuboidDetection_naivy(myPlanes, th_angle, unassignedPlanes);
else
        %perform pair cuboid detection between assigned and unassigned planes
        cuboidDetection_pair(myPlanes, th_angle, unassignedPlanes, assignedPlanes)
end

unassignedPlanes=[];
[assignedPlanes unassignedPlanes] = updateAssignedPlanes({myPlanes{initIndex+1:end}});
assignedPlanes=assignedPlanes+initIndex;
unassignedPlanes=unassignedPlanes+initIndex;
end
