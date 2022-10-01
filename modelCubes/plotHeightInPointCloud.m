clc
close all
clear

% set parameters
rootPath="C:\lib\boxTrackinPCs\";
scene=5;%
frame=5;

%% load point cloud from frame
% load point cloud in h
pc_h=loadPointCloud(rootPath,scene, frame);%length in mm

%% change height coordinate from y to z and keep relationships of hand right rule
x=pc_h.Location(:,1);
y=pc_h.Location(:,2);
z=pc_h.Location(:,3);

% load height offset from ground plane model

planesPath=rootPath + 'scene' + num2str(scene) + '\detectedPlanes\frame' + num2str(frame) + '\';
[modelParameters] = loadPlaneParameters(planesPath,frame,1);
xyz=[z x y+(abs(modelParameters(4))*0)];
pc=pointCloud(xyz);

% load camera pose in mm
[Th_c Th_c_raw] = loadTh_c(rootPath,scene,frame);
% transfrom Th_c to z height
% T=eye(4);
% T(1:3,4)=[Th_c(3,4) Th_c(1,4) Th_c(2,4)]';
% T(:,1)=Th_c(:,3);
% T(:,2)=Th_c(:,1);
% T(:,3)=Th_c(:,2);

figure,
    pcshow(pc_h)
    hold on
    dibujarsistemaref(eye(4),'h',1000,1,10,'w');
    dibujarsistemaref(Th_c_raw,'c',1000,1,10,'w');
    grid on
    xlabel 'x'
    ylabel 'y'
    zlabel 'z'
    title 'Raw pc. Height in y axis'


figure,
    pcshow(pc)
    hold on
    dibujarsistemaref(eye(4),'h',1000,1,10,'w');
    dibujarsistemaref(Th_c,'c',1000,1,10,'w');
    grid on
    xlabel 'x'
    ylabel 'y'
    zlabel 'z'
    title 'height in z axis'
