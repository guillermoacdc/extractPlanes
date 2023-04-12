function [localAssignedP, localUnassignedP] = cuboidDetectionAndUPdate_pair(myPlanes, ...
        th_angle, planeIndex, searchSpaceIndex, conditionalAssignationFlag,...
        globalAcceptedPlanes)
%CUBODIDETECTIONANDUPDATE This function performs cuboid detection and
%update of the lists localAssignedP and localUnassingeP. The detection is
%performed between planes of the same type or tilt, i.e. between top planes
%or between xyTilt Planes
%   Detailed explanation goes here

% extract types
[xzPlanes, xyPlanes, zyPlanes]=extractTypes(myPlanes, planeIndex);
[ss_xzPlanes, ss_xyPlanes, ss_zyPlanes]=extractTypes(myPlanes, ...
    searchSpaceIndex);
% detect cuboids by type and update

if ~isempty(xzPlanes)
    if ~isempty(ss_xyPlanes)
        cuboidDetection_pair_v7(myPlanes, th_angle, xzPlanes, ss_xyPlanes,...
        conditionalAssignationFlag);
    end
    if ~isempty(ss_zyPlanes)
        cuboidDetection_pair_v7(myPlanes, th_angle, xzPlanes, ss_zyPlanes,...
        conditionalAssignationFlag);
    end
end

if ~isempty(xyPlanes)
    if ~isempty(ss_xzPlanes)
        cuboidDetection_pair_v7(myPlanes, th_angle, xyPlanes, ss_xzPlanes,...
        conditionalAssignationFlag);
    end
    if ~isempty(ss_zyPlanes)
        cuboidDetection_pair_v7(myPlanes, th_angle, xyPlanes, ss_zyPlanes,...
        conditionalAssignationFlag);
    end
end

if ~isempty(zyPlanes)
    if ~isempty(ss_xzPlanes)
        cuboidDetection_pair_v7(myPlanes, th_angle, zyPlanes, ss_xzPlanes,...
        conditionalAssignationFlag);
    end
    if ~isempty(ss_xyPlanes)
        cuboidDetection_pair_v7(myPlanes, th_angle, zyPlanes, ss_xyPlanes,...
        conditionalAssignationFlag);
    end
end

localAssignedP=updateAssignedPlanes_v4(myPlanes);
localUnassignedP=setdiff_v2(globalAcceptedPlanes, localAssignedP);

end

