function [pc] = fusePointCloudsFromDetectedPlanes_v2(localPlanes,gridStep, flagGroundPlane, acceptedPlanes)
%UNTITLED fuse point clouds from detected planes from a single scene
% assumption: the detected planes (localPlanes) come from a single scene
%   Detailed explanation goes here
% _v2: adds the input acceptedPlanes. Allows to control wich planes are
% fused


frame_cell=fieldnames(localPlanes(1)); 
frame_str=cell2mat(frame_cell);
if nargin==3
% extract accepted planes
    acceptedPlanes=localPlanes.(frame_str).acceptedPlanes;        
end

if flagGroundPlane
    acceptedPlanes=[acceptedPlanes(1,1) 1; acceptedPlanes];
end
N=size(acceptedPlanes,1);

for i=1:N

    plane=acceptedPlanes(i,2);
    path_t=localPlanes.(frame_str).values(plane).pathPoints;
    pc_t=pcread(path_t);
    % convert lengths to mm
    xyz=pc_t.Location*1000;
    pc_t_mm=pointCloud(xyz);
    if (i==1)
        pc=pc_t_mm;%initial value of point cloud
    else
        pc=pcmerge(pc_t_mm,pc,gridStep);
    end
end

end



