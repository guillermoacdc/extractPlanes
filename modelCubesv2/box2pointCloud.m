function pointCloud_box = box2pointCloud(boxObject,NpointsDiagTopSide,...
    gridStep)
%BOX2POINTCLOUD Summary of this function goes here
%   Detailed explanation goes here
planeDescriptor = box2planeObject(boxObject);

pointCloud_box=createSyntheticPC_v3(planeDescriptor,NpointsDiagTopSide, gridStep);

end

