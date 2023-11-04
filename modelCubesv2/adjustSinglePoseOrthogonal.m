function adjustSinglePoseOrthogonal(globalPlanes, indexes, qcase)
% adjustSinglePoseOrthogonal. performs and adjustem of pose in the element
% globalPlanes(indexes(2)) to warrant orthogonality between top and
% perpendicular plane
% assumption: index 1 is pointing to top plane, index 2 is pointing to
% perpendicular plane

% [~,er]=computeSinglePoseError(globalPlanes(indexes(1)).tform,...
%     globalPlanes(indexes(2)).tform);
% qcase=computeCaseAdjustemtPose(er, globalPlanes, indexes);
switch(qcase)
    case 1
        alpha=0;
    case 2
        alpha=90;
    case 3
        alpha=180;
    case 4
        alpha=-90;
    otherwise
        disp('error in side value from adjustSinglePoseOrthogonal');
end
if alpha~=0
    globalPlanes(indexes(2)).tform(1:3,1:3)=roty(alpha)*globalPlanes(indexes(1)).tform(1:3,1:3);
else
    globalPlanes(indexes(2)).tform(1:3,1:3)=globalPlanes(indexes(1)).tform(1:3,1:3);
end

end