 function [localAssignedP, localUnassignedP] = cuboidDetectionAndUPdate(globalPlanes, ...
        th_angle, conditionalAssignationFlag)
%CUBODIDETECTIONANDUPDATE This function performs cuboid detection and
%update of the lists localAssignedP and localUnassingeP. The detection is
%performed between planes of the same type or tilt, i.e. between top planes
%or between xyTilt Planes
%   Detailed explanation goes here
% globalAcceptedPlanes=extractIDsFromVector(globalPlanes.values);
% extract types
[xzPlanes, xyPlanes, zyPlanes]=extractTypes_vcuboids(globalPlanes);
% detect cuboids by type and update

% detection for xzPlanes
if ~isempty(xzPlanes)
    if ~isempty(xyPlanes)
        cuboidDetection_pair_v7(globalPlanes, th_angle, xzPlanes,...
            xyPlanes, conditionalAssignationFlag);
    end

    if ~isempty(zyPlanes)
        cuboidDetection_pair_v7(globalPlanes, th_angle, xzPlanes,...
            zyPlanes, conditionalAssignationFlag);
    end
else
    if ~isempty(xyPlanes) & ~isempty(zyPlanes)
        cuboidDetection_pair_v7(globalPlanes, th_angle, xyPlanes,...
            zyPlanes, conditionalAssignationFlag);
    end
end


localAssignedP=updateAssignedPlanes_v4(globalPlanes);
globalAcceptedPlanes=extractIDsFromVector(globalPlanes);
localUnassignedP=setdiff_v2(globalAcceptedPlanes, localAssignedP);

end

