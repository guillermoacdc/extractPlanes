function pc_filtered=filterRawPC(pc_mm,maxDistance,refVector,...
    cameraPosition, opRange)
%FILTERRAWPC Filter a point cloud frame with three stages: (1) removes
%ground plane points, (2) removes points that are outside of the operating
%range of the sensor
%   Detailed explanation goes here

% 1. delete ground plane
% maxDistance=20;%mm
% refVector=[0 1 0];
[model,inlierIndices,outlierIndices] = pcfitplane(pc_mm,maxDistance,refVector);

xyz=pc_mm.Location(outlierIndices,:);
pc_woutGround=pointCloud(xyz);

% 2 detect points that are outside the operating range of the sensor and
% delete them
% cameraPoses=importdata(rootPath+['scene' num2str(scene)]+'\Depth Long Throw_rig2world.txt');
% cameraPosition=cameraPoses(frame,[5 9 13])*1000;
% opRange=[0.5 3]*1000;%[min max] in mm

[inlierIndices outlierIndices]=mypcFilterByOpRange(pc_woutGround,opRange,cameraPosition);

xyz=pc_woutGround.Location(inlierIndices,:);
pc_filtered=pointCloud(xyz);


end

