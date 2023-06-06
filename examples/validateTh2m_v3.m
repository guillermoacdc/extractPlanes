clc
close all
clear all

% _v3: consuming data form 6dViCuT path
scene=27;

% 1. Plane filtering parameters
th_angle=15*pi/180;%radians
th_size=150;%number of points
th_lenght=10*10;%mm 10 cm - Update with tolerance_length; is in a high value (30) to pass most of the planes
th_occlusion=1.4;%
D_Tolerance=0.1*1000;%mm ... 0.1 m
planeFilteringParameters=[th_lenght, th_size, th_angle, th_occlusion, D_Tolerance];

% 2 path parameters
processedScenesPath='G:\Mi unidad\semestre 9\lowOcclusionScenes_processed';
rootPath=computeMainPaths(scene);

flagGroundPlane=false;
outputFileName='Th2m.txt';
pathInitValue=fullfile(rootPath,[ 'session' num2str(scene)],'analyzed',outputFileName)
% pathInitValue=['G:\Mi unidad\boxesDatabaseSample\corrida' num2str(scene) '\Th2m.txt'];
T_initialValue=load(pathInitValue);

% [reposFlag,reposFrame] = isRepositioned(rootPath,scene,2);
reposFlag=false;

frames = getTargetFramesFromScene(scene);
idxBoxes=getIDxBoxes(rootPath,scene);

frame=frames(2);
fileName=['frame'  num2str(frame)  '.ply'];
pathPoints=fullfile(rootPath, ['session' num2str(scene)], 'filtered', 'HL2', 'PointClouds', fileName );
% pathPoints=[rootPath + 'corrida' + num2str(scene) + '\HL2\PointClouds\frame' + num2str(frame) + '.ply'];

gridStep=1;
%% Generate synthetic model points
% spatialSampling=10;
numberOfSides=3;
NpointsDiagTopSide=60;
planeType=0;
boxIDref=getPPS(rootPath,scene,frame);
[pcmodel, planeDescriptor_gt] = generateSyntheticPC(boxIDref,scene, ...
    numberOfSides, frame, NpointsDiagTopSide, planeType, rootPath);
Nboxes=size(planeDescriptor_gt.fr0.values,2);


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
%     localPlanes=detectPlanes(rootPath,scene,frame, processedScenesPath);
    localPlanes=loadExtractedPlanes(rootPath,scene,frame,...
        processedScenesPath, planeFilteringParameters);%
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
