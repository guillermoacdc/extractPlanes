clc
close all
clear all
% path to extracted planes
% processedScenesPath='G:\Mi unidad\semestre 9\HighOcclusionScenes_processed';
processedScenesPath='G:\Mi unidad\semestre 9\MediumOcclusionScenes_processed';
% processedScenesPath='G:\Mi unidad\semestre 9\lowOcclusionScenes_processed';

% rootPath
rootPath="G:\Mi unidad\boxesDatabaseSample\";

flagGroundPlane=false;
scene=5;
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


%% Load data points
% validate with coloured point cloud
% convert frame to timestamp names:132697151634073057.ply ---> 25
% load colured point cloud
% G:\Mi unidad\boxesDatabaseSample\corrida5\HL2\Depth Long Throw
fileName=['G:\Mi unidad\boxesDatabaseSample\corrida5\HL2\Depth Long Throw\132697151634073057.ply' ]
pc_h_mt = pcread(fileName);
% convert to mm
xyz=pc_h_mt.Location;
xyzmm=xyz*1000;
pc_h=pointCloud(xyzmm);


% validate with fused non-coloured pcs
% fusion two consecutive frames in their accepted planes version
for i=1:length(frames)
    frame=frames(i);
    localPlanes=detectPlanes(rootPath,scene,frame, processedScenesPath);
    pc_singleFrame{i}=fusePointCloudsFromDetectedPlanes(localPlanes,gridStep,flagGroundPlane);
end
% pc_h = pcmerge(pc_singleFrame{1},pc_singleFrame{2},gridStep);


    Tm_h=assemblyTmatrix(T_initialValue);
% transform from h to m worlds
    pc_m=myProjection_v3(pc_h,Tm_h);
data=pc_m.Location;
pc_woutGround=pointCloud(data);
pc_woutGround.Color=pc_h_mt.Color;



xmin=-1500;
xmax=1500;
ymin=-10;
ymax=2500;
zmin=-100;
zmax=600;


% plot synthetic pc with coordinate frames
figure,
hold on
pcshow(pcmodel)
for i=1:Nboxes
    boxID=planeDescriptor_gt.fr0.values(i).idBox;
    Tm=planeDescriptor_gt.fr0.values(i).tform;
    dibujarsistemaref(Tm,boxID,150,2,10,'k');
end
T0=eye(4);
dibujarsistemaref(T0,'m',150,2,10,'k');
T1=localPlanes.fr25.cameraPose;
T1(1:3,4)=T1(1:3,4)*1000;%convert to mm
T1=Tm_h*T1;
dibujarsistemaref(T1,'c',150,2,10,'k');
axis([xmin xmax ymin ymax zmin 1600])
xlabel 'x'
ylabel 'y'
zlabel 'z'
grid on
title (['synthetic pc from scene ' num2str(scene)])

% plot colored pc, synthetic pc and coordinate frames
figure,
pcshow(pc_woutGround,"MarkerSize",10)%colored point cloud projected to mocap reference system
hold on
pcshow(pcmodel)%synthetic model
for i=1:Nboxes
    boxID=planeDescriptor_gt.fr0.values(i).idBox;
    Tm=planeDescriptor_gt.fr0.values(i).tform;
    if (boxID==14|boxID==18) 
        dibujarsistemaref(Tm,boxID,150,2,10,'y');
    else
        dibujarsistemaref(Tm,boxID,150,2,10,'k');
    end
    
    
end
T0=eye(4);
dibujarsistemaref(T0,'m',150,2,10,'k');
dibujarsistemaref(T1,'c',150,2,10,'k');
axis([xmin xmax ymin ymax zmin 1600])
xlabel 'x'
ylabel 'y'
zlabel 'z'
grid on
title (['pc from HL2 scene/frame ' num2str(scene) '/' num2str(frame)])

% create new figure with
% 1. non colored point cloud projected to mocap coordinate frame
% 2. fixed HL2 coordinate frame projected to mocap coordinate frame
% 3. mocap coordinate frame
% 4. mobile HL2 coordinate frame

