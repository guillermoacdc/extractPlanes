function includePreviousKnowledge_Plane_v2(planeDescriptor, th_lenght, th_size, ...
        th_angle, th_occlusion, D_Tolerance, groundNormal, groundD, lengthBoundsTop,...
        lengthBoundsP, plotFlag)
%INLCUDEPREVIOUSKNOWLEDGE_PLANE implements the strategy to include previous
%knowledge in the plane extraction stage
%   _v2 reorder of the stages to reduce computational complexity

% first filtering. Apply just for top planes
if (planeDescriptor.type==0)
    D_ToleranceFlag=heightFilterPrllel(groundD,planeDescriptor.D,D_Tolerance);
    planeDescriptor.setDFlag(D_ToleranceFlag);
    if D_ToleranceFlag==1
        return
    end
end
% load of point cloud
pc = pcread(planeDescriptor.pathPoints);%in [mt]; indices begin at 0
%     classify the plane object
planeDescriptor.classify(pc, th_angle, groundNormal);%
if (planeDescriptor.type~=2)%avoid computation on non-expected planes
% set limits and update geometric center. The update is necessary to include the projection of points to
%     the plane model before compute g.c. 
planeDescriptor.setLimits(pc);%set limits in each axis.
%     detect antiparallel normals and correct
planeDescriptor.correctAntiparallel(th_size);%
% measure pose and length, and updata occlusion flag
planeDescriptor.measurePoseAndLength(pc, th_occlusion, plotFlag);
% set length flag based on type of plane
if planeDescriptor.type==0
    lengthFlag=lengthFilter(planeDescriptor,lengthBoundsTop,th_lenght);
else
    lengthFlag=lengthFilter(planeDescriptor,lengthBoundsP,th_lenght);
end
planeDescriptor.setLengthFlag(lengthFlag);
end
% --------------


end

