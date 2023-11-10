 function [group_tpp, group_tp, group_s] = firstGrouping(globalPlanes, ...
        th_angle, conditionalAssignationFlag)
%FIRSTGROUPING This function performs grouping strategies btwn plane segments
% that belong to globalPlanes vector. Generates three outputs
% group_tpp: triads of (top, perpendicular, perpendicular) planes
% group_tp: couples of (top, perpendicular) planes
% group_s: single planes that didnt find couple. Those could be top or perpendicular
th_angle=th_angle+2;
% clear secondPlaneID and thirdPlanID from global planes
myClearSecondAndThirdPlaneID(globalPlanes.values);

% [xzPlanes, xyPlanes, zyPlanes]=extractTypes_vcuboids(globalPlanes);
% detect cuboids by type and update

% detection for xzPlanes
if ~isempty(globalPlanes.xzIndex)
    if ~isempty(globalPlanes.xyIndex)
        cuboidDetection_pair_v7(globalPlanes.values, th_angle, globalPlanes.xzIndex,...
            globalPlanes.xyIndex, conditionalAssignationFlag);
    end

    if ~isempty(globalPlanes.zyIndex)
        cuboidDetection_pair_v7(globalPlanes.values, th_angle, globalPlanes.xzIndex,...
            globalPlanes.zyIndex, conditionalAssignationFlag);
    end
else
    if ~isempty(globalPlanes.xyIndex) & ~isempty(globalPlanes.zyIndex)
        cuboidDetection_pair_v7(globalPlanes.values, th_angle, globalPlanes.xyIndex,...
            globalPlanes.zyIndex, conditionalAssignationFlag);
    end
end

% [group_tpp, group_tp, group_s]=updateGroups(globalPlanes);
[group_tpp, group_tp, group_s]=updateGroups(globalPlanes.values);

end

