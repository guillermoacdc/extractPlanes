function adjustPoseOrthogonal_v2(globalPlanes,group_tpp)
%ADJUSTPOSEORTHOGONAL Perform and adjust in the pose of perpendicular
% planes that compose a box, to warrant orthogonality.
% assumption: 
% 1. the z axis in each coordinate system of perpendicular planes is
% paralel to the normal vector
% 2. the y axis in each coordinate system of all planes, is parallel to
% antigravity vector
% 3. all coordinate systems satisfy right hand rule
% 4. the first index in group_tpp points to a top plane; the other indexes
% point to perpendicular planes
% 5. The set of planes pointed in group_tpp compose a single box
% 6. The box is composed by three planes

% adjust single pose for first perpendicular plane
adjustSinglePoseOrthogonal(globalPlanes, [group_tpp(1),group_tpp(2)]);
% adjust single pose for second perpendicular plane
adjustSinglePoseOrthogonal(globalPlanes, [group_tpp(1),group_tpp(3)]);
end

