clc
close all
clear all
% path to extracted planes
% processedScenesPath='G:\Mi unidad\semestre 9\HighOcclusionScenes_processed';
% processedScenesPath='G:\Mi unidad\semestre 9\MediumOcclusionScenes_processed';
processedScenesPath='G:\Mi unidad\semestre 9\lowOcclusionScenes_processed';

% rootPath
rootPath="G:\Mi unidad\boxesDatabaseSample\";

flagGroundPlane=false;
scene=3;
pathInitValue=['G:\Mi unidad\boxesDatabaseSample\corrida' num2str(scene) '\Th2m.txt'];
T_initialValue=load(pathInitValue);

[reposFlag,reposFrame] = isRepositioned(rootPath,scene,2);


frames = getTargetFramesFromScene(scene);
idxBoxes=getIDxBoxes(rootPath,scene);

frame=frames(2);
pathPoints=[rootPath + 'corrida' + num2str(scene) + '\HL2\PointClouds\frame' + num2str(frame) + '.ply'];

gridStep=1;
%% Generate synthetic model points
spatialSampling=10;
numberOfSides=3;
% groundFlag=true;
[pcmodel, planeDescriptor_gt, Nboxes] = generateSyntheticModelForScene(rootPath, ...
    scene,spatialSampling,numberOfSides,flagGroundPlane, idxBoxes, reposFrame);
figure,
hold on
pcshow(pcmodel)
for i=1:Nboxes
    boxID=planeDescriptor_gt.fr0.values(i).idBox;
    Tm=planeDescriptor_gt.fr0.values(i).tform;
    dibujarsistemaref(Tm,boxID,150,2,10,'w');
end
xlabel 'x'
ylabel 'y'
zlabel 'z'
grid on
title (['synthetic pc from scene ' num2str(scene)])

%% Load data points
% fusion two consecutive frames in their accepted planes version

% 132697151634073057.ply ---> 25
for i=1:length(frames)
    frame=frames(i);
    localPlanes=detectPlanes(rootPath,scene,frame, processedScenesPath);
    pc_singleFrame{i}=fusePointCloudsFromDetectedPlanes(localPlanes,gridStep,flagGroundPlane);
end
pc_h = pcmerge(pc_singleFrame{1},pc_singleFrame{2},gridStep);


    Tm_h=assemblyTmatrix(T_initialValue);
% transform from h to m worlds
    pc_m=myProjection_v3(pc_h,Tm_h);
data=pc_m.Location;
pc_woutGround=pointCloud(data);

figure,
pcshow(pc_woutGround,"MarkerSize",10)
hold on
% add box ID to the figure
for i=1:Nboxes
    boxID=planeDescriptor_gt.fr0.values(i).idBox;
    Tm=planeDescriptor_gt.fr0.values(i).tform;
    dibujarsistemaref(Tm,boxID,150,2,10,'w');
end
hold on
pcshow(pcmodel)
xlabel 'x'
ylabel 'y'
zlabel 'z'
grid on
title (['pc from HL2 scene/frame ' num2str(scene) '/' num2str(frame)])
