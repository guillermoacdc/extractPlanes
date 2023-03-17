% special version created for scene 2. It merges 12 consecutive frames
clc
close all
clear

% scene=3;%
% frames=[48 49];
processedScenesPath='G:\Mi unidad\semestre 9\MediumOcclusionScenes_processed';
rootPath="G:\Mi unidad\boxesDatabaseSample\";
flagGroundPlane=false;
scene=4;
frames = getTargetFramesFromScene(scene);
idxBoxes=getPPS(rootPath,scene);

gridStep=1;

for i=1:length(frames)
    frame=frames(i);
    localPlanes=detectPlanes(rootPath,scene,frame, processedScenesPath);
    pc_singleFrame{i}=fusePointCloudsFromDetectedPlanes(localPlanes,gridStep,flagGroundPlane);
end

k=1;
for i=1:2:11
    pc_l1{k}=pcmerge(pc_singleFrame{i},pc_singleFrame{i+1},gridStep);
    k=k+1;
end

k=1;
for i=1:2:5
    pc_l2{k}=pcmerge(pc_l1{i},pc_l1{i+1},gridStep);
    k=k+1;
end

pcl3_1 = pcmerge(pc_l2{1},pc_l2{2},gridStep);
pc_h = pcmerge(pcl3_1,pc_l2{3},gridStep);


figure,
pcshow(pc_h)
xlabel 'x'
ylabel 'y'
zlabel 'z'
title ('fused version in a single point cloud')

figure,
pcshow(pc_singleFrame{8})
hold on
pcshow(pc_singleFrame{9})
xlabel 'x'
ylabel 'y'
zlabel 'z'
title ('non - fused version in a single point cloud')
