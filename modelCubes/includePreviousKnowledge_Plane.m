function includePreviousKnowledge_Plane(planeDescriptor, th_lenght, th_size, ...
        th_angle, th_occlusion, D_Tolerance, groundNormal, groundD, lengthBounds, plotFlag)
%INLCUDEPREVIOUSKNOWLEDGE_PLANE implements the strategy to include previous
%knowledge in the plane extraction stage
%   Detailed explanation goes here


pc = pcread(planeDescriptor.pathPoints);%in [mt]; indices begin at 0
%     classify the plane object
planeDescriptor.classify(pc, th_angle, groundNormal);%

%     update geometric center and compute bounds of the projected point
%     cloud. The update is necessary to include the projection of points to
%     the plane model before compute g.c. 
planeDescriptor.setLimits(pc);%set limits in each axis.

%     detect antiparallel normals and correct
planeDescriptor.correctAntiparallel(th_size);%


%     filter parallel planes by parameter D; 
if (planeDescriptor.type==0)
    D_ToleranceFlag=heightFilterPrllel(groundD,planeDescriptor.D,D_Tolerance);
    planeDescriptor.setDFlag(D_ToleranceFlag);
end

%     compute L1, L2 and tform
if (planeDescriptor.type==2)%avoid computation on non-expected planes
%    Non-expected planes can not be filtered by length
    return
else
        planeDescriptor.measurePoseAndLength(pc, th_occlusion, plotFlag)
end
%     filter planes by Length.
    lengthFlag=lengthFilter(planeDescriptor,lengthBounds,th_lenght);
    planeDescriptor.setLengthFlag(lengthFlag);


end

