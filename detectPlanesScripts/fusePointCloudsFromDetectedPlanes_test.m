clc
close all
clear

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
pc = pcmerge(pc_singleFrame{1},pc_singleFrame{2},gridStep);
figure,
pcshow(pc)
xlabel 'x'
ylabel 'y'
zlabel 'z'
title ('fused version in a single point cloud')
return
figure,
pcshow(pc_singleFrame{1})
hold on
pcshow(pc_singleFrame{2})
xlabel 'x'
ylabel 'y'
zlabel 'z'
title ('non - fused version in a single point cloud')
