function [pc] = createPlanePCAtOriginOfqh(planeDescriptor,spatialSampling)
%CREATEPLANEPCATORIGIN Creates a point cloud of a plane, centered at origin
    [x,y,z] = ndgrid(0:spatialSampling:planeDescriptor.L2, 0, 0:spatialSampling:planeDescriptor.L1);
    xyz=[x(:),y(:),z(:)];
    %     put the origin of the plane in the geometric center
    T1=[1 0 0 -planeDescriptor.L2/2; 0 1 0 0;0 0 1 -planeDescriptor.L1/2; 0 0 0 1];
    for i=1:size(xyz,1)
        xyza=T1*[xyz(i,:) 1]';
        xyz(i,:)=xyza(1:3)';
    end
    pc=pointCloud(xyz);
    pc=myProjection_v3(pc,planeDescriptor.tform);
%     pc=myProjection_v3(pc,T1);

%     figure,
%     pcshow(pc)
%     xlabel x
%     ylabel y
%     zlabel z

end

