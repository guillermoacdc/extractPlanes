function pc = loadPlanePointCloud(rootPath)
%LOADPOINTCLOUD Summary of this function goes here
% assumes that the raw point cloud is in meters
%   returns pc in mm
% filePath=rootPath  + 'scene' + num2str(scene)+'\inputFrames\frame'+num2str(frame)+'.ply';
pc1=pcread(rootPath);%length in mt
xyzPoints=pc1.Location*1000;
pc= pointCloud(xyzPoints);

end

