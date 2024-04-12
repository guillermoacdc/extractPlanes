function [group_tpp, group_tp, group_s, globalPlanes] = groupSegments(globalPlanes, ...
        th_angle, conditionalAssignationFlag)
%GROPUSEGMENTS This function performs grouping strategies btwn plane segments
% that belong to globalPlanes vector. Generates three outputs, each one is
% a vector of indexes
% group_tpp: each element point to a top plane segment ps in globalPlanes, 
% where a second and third plane has been identified for ps. tpp is for top,
% perpendicular, perpendicular 
% group_tp: each element point to a top plane segment ps in globalPlanes, 
% where a second plane has been identified for ps. tp is for top,
% perpendicular
% group_s: each element point to a plane segment ps in globalPlanes, 
% without partners. s is for single plane
th_angle=th_angle+2;
% clear secondPlaneID and thirdPlanID from global planes
myClearSecondAndThirdPlaneID(globalPlanes.values);

% [xzPlanes, xyPlanes, zyPlanes]=extractTypes_vcuboids(globalPlanes);
% detect cuboids by type and update

% detection for xzPlanes
if ~isempty(globalPlanes.xzIndex)
    if ~isempty(globalPlanes.xyIndex)
        globalPlanes.values=cuboidDetection_pair_v8(globalPlanes.values, th_angle, globalPlanes.xzIndex,...
            globalPlanes.xyIndex, conditionalAssignationFlag);
    end

    if ~isempty(globalPlanes.zyIndex)
        globalPlanes.values=cuboidDetection_pair_v8(globalPlanes.values, th_angle, globalPlanes.xzIndex,...
            globalPlanes.zyIndex, conditionalAssignationFlag);
    end

end

[group_tpp, group_tp, group_s]=updateGroups(globalPlanes.values);

end

