function fillDerivedDescriptors_PK(planeDescriptor, th_lenght, th_size, ...
        th_angle, th_occlusion, D_Tolerance, groundNormal, groundD, lengthBoundsTop,...
        lengthBoundsP, plotFlag)
%fillDerivedDescriptors_PK computes derived descriptors for planes, based on
%assumptions and previous knowledge (PK) of the scene.


% load of point cloud
% pc = pcread(planeDescriptor.pathPoints);%in [mt]; indices begin at 0
pc = myPCread(planeDescriptor.pathPoints);% in mm

%     classify the plane object in the categories type, xyTilt
planeDescriptor.classify(pc, th_angle, groundNormal);%

if (planeDescriptor.type~=2)%avoid computation on non-expected planes
    % first filtering. Apply just for top planes
    if (planeDescriptor.type==0)
        D_ToleranceFlag=heightFilterPrllel(groundD,planeDescriptor.D,D_Tolerance);
        planeDescriptor.setDFlag(D_ToleranceFlag);
        if D_ToleranceFlag==1
            return
        end
    end
    
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

