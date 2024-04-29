function pointCloud_box = box2pointCloud_vss(boxObject,ss,...
    gridStep)
%BOX2POINTCLOUD Summary of this function goes here
%   Detailed explanation goes here
% vss: this version uses a single spatial sampling (ss) for the whole box 
% instead of computing ss for each plane segment
planeDescriptor = box2planeObject(boxObject);

pointCloud_box=createSyntheticPC_vss(planeDescriptor,ss, gridStep);

end

