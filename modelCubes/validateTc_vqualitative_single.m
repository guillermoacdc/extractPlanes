% script to validate Th_c and Tm_c
clc
close all
clear

% set parameters
rootPath="C:\lib\boxTrackinPCs\";
scene=5;%
frame=4;

%% load point cloud from frame
% load point cloud in h
pc_h=loadPointCloud(rootPath,scene, frame);%length in mm


%% compute Tm_h
% load Th_c, Tm_c
Th_c=loadTh_c(rootPath,scene,frame);
Tm_c=loadTm_c(rootPath,scene,frame);

% compute Tm_h
    Tm_h=Tm_c*inv(Th_c);

% transform point cloud to mocap framework
pc_m=myProjection_v3(pc_h,Tm_h);

figure,
    pcshow(pc_m)
    hold on
    dibujarsistemaref(eye(4),'m',1000,1,10,'w');
    dibujarsistemaref(Tm_c,'c',1000,1,10,'w');
    dibujarsistemaref(Tm_h,'h',1000,1,10,'w');
    view(-45*3,30)
    title (['Projected point cloud from frame ' num2str(frame) ', scene ' num2str(scene)])
    xlabel 'x'
    ylabel 'y'
    zlabel 'z'
    grid on

return
% add box framework to the figure
% keyplaneID=[5 2];%[2 9]
frame=keyplaneID(1);
%     detect planes in frame 
localPlanes=detectPlanes(rootPath,scene,frame);
%     extract geometric center of plane 
keyPlane=loadPlanesFromIDs(localPlanes,keyplaneID);
TkeyPlane_h=keyPlane.tform;%in mt
TkeyPlane_h(1:3,4)=TkeyPlane_h(1:3,4)*1000;%in mm

figure,
    pcshow(pc_h)
    hold on
    dibujarsistemaref(eye(4),'h',1000,1,10,'w');
    dibujarsistemaref(TkeyPlane_h,'b',1000,1,10,'w');
    camup([0 1 0])
    title 'Raw point cloud'
    xlabel 'x'
    ylabel 'y'
    zlabel 'z'
    grid on


% figure,
%     dibujarsistemaref(Th_c,'Th_c',1000,1,10,'b');
%     hold on
%     dibujarsistemaref(Tm_c,'Tm_c',1000,1,10,'b');
%     dibujarsistemaref(Tm_h,'Tm_h',1000,1,10,'b');
%     camup([0 1 0])
%     title 'Main transformation'
%     xlabel 'x'
%     ylabel 'y'
%     zlabel 'z'
%     grid on
