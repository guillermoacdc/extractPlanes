function [pc] = createPlanePCAtOrigin_v2(planeDescriptor,spatialSampling)
%CREATEPLANEPCATORIGIN Creates a point cloud of a plane, centered at origin
    if mod(planeDescriptor.idPlane,2)==0
        evenSide=true;
    else
        evenSide=false;
    end
    rotateCondition=(planeDescriptor.type==1)*(~evenSide*planeDescriptor.L2toY+evenSide*(~planeDescriptor.L2toY));
    if  rotateCondition
%         rotz(90)
        [x,y,z] = ndgrid(0:spatialSampling:planeDescriptor.L2,  0:spatialSampling:planeDescriptor.L1, 0);
        T1=[1 0 0 -planeDescriptor.L2/2; 0 1 0 -planeDescriptor.L1/2;0 0 1 0; 0 0 0 1];
    else
        [x,y,z] = ndgrid(0:spatialSampling:planeDescriptor.L1,  0:spatialSampling:planeDescriptor.L2, 0);
        %     put the origin of the plane in the geometric center
        T1=[1 0 0 -planeDescriptor.L1/2; 0 1 0 -planeDescriptor.L2/2;0 0 1 0; 0 0 0 1];
    end
    xyz=[x(:),y(:),z(:)];
    
    for i=1:size(xyz,1)
        xyza=T1*[xyz(i,:) 1]';
        xyz(i,:)=xyza(1:3)';
    end
    pc=pointCloud(xyz);
    pc=myProjection_v3(pc,planeDescriptor.tform);
end

