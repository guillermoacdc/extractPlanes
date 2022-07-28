 function [localAssignedP, localUnassignedP] = cuboidDetectionAndUPdate(myPlanes, ...
        th_angle, planeIndex,conditionalAssignationFlag,...
        globalAcceptedPlanes)
%CUBODIDETECTIONANDUPDATE This function performs cuboid detection and
%update of the lists localAssignedP and localUnassingeP. The detection is
%performed between planes of the same type or tilt, i.e. between top planes
%or between xyTilt Planes
%   Detailed explanation goes here

% extract types
[xzPlanes xyPlanes zyPlanes]=extractTypes(myPlanes, planeIndex);
% detect cuboids by type and update

% detection for xzPlanes
if ~isempty(xzPlanes)
    if ~isempty(xyPlanes)
        cuboidDetection_pair_v7(myPlanes, th_angle, xzPlanes,...
            xyPlanes, conditionalAssignationFlag);
    end

    if ~isempty(zyPlanes)
        cuboidDetection_pair_v7(myPlanes, th_angle, xzPlanes,...
            zyPlanes, conditionalAssignationFlag);
    end
else
    if ~isempty(xyPlanes) & ~isempty(zyPlanes)
        cuboidDetection_pair_v7(myPlanes, th_angle, xyPlanes,...
            zyPlanes, conditionalAssignationFlag);
    end
end


localAssignedP=updateAssignedPlanes_v4(myPlanes);
localUnassignedP=setdiff_v2(globalAcceptedPlanes, localAssignedP);

end

