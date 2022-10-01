% script to validate Th_c and Tm_c
clc
close all
clear

% set parameters

scene=6;%
rootPath="C:\lib\boxTrackinPCs\";
% keyboxID=14;%expected L1(30), L2(40)
% keyplaneID=[69 2];%[2 9]
% frame=keyplaneID(1);

%load key frames
keyframes=loadKeyFrames(rootPath,scene);
Nf=size(keyframes,2);

% % load keybox pose in m world
% [Tkeybox_m,~,~]=loadGTData(rootPath, scene, 15);

idx=8;
%% Perform Tkeyplane  pose estimation in mm
%     detect planes in frame 
localPlanes=detectPlanes(rootPath,scene,keyframes(idx));

figure,
myPlotPlanes_v2(localPlanes,localPlanes.(['fr' num2str(keyframes(idx))]).acceptedPlanes);
title (['Scene ' num2str(scene) ', frame ' num2str(keyframes(idx))])
return
%     extract geometric center of plane 
keyPlane=loadPlanesFromIDs(localPlanes,keyplaneID);
TkeyPlane_h=keyPlane.tform;%in mt
TkeyPlane_h(1:3,4)=TkeyPlane_h(1:3,4)*1000;%in mm

% load point cloud of keyplane
pc_h=loadPlanePointCloud(keyPlane.pathPoints);


    % load Th_c, Tm_c
    Th_c=loadTh_c(rootPath,scene,frame);
    Tm_c=loadTm_c(rootPath,scene,frame);
    % compute Tm_h
    Tm_h=Tm_c*inv(Th_c);

    % transform from h to m worlds

    Theight=eye(4);
    Theight(1:3,1:3)=[1 0 0; 0 0 1; 0 -1 0];

    TkeyPlane_m=Tm_h*TkeyPlane_h*Theight;
    [ets,ers] = computeSinglePoseError(TkeyPlane_m,Tkeybox_m);
    pc_m=myProjection_v3(pc_h,Tm_h);

% plot in h world
figure,
    myPlotPlanes_v2(localPlanes, [keyplaneID; 5 6; 5 10])
%     myPlotPlanes_v2(localPlanes, localPlanes.fr5.acceptedPlanes)
    hold on
    dibujarsistemaref(eye(4),'h',1,1,10,'b')
    TkeyPlane_h_mt=TkeyPlane_h;
    TkeyPlane_h_mt(1:3,4)=TkeyPlane_h_mt(1:3,4)/1000;
    dibujarsistemaref(TkeyPlane_h_mt,'b_h',1,1,10,'b')
    title 'Points in h world'
    camup([0 1 0])


%     plot in m world
    figure,
        pcshow(pc_m)
        hold on
        % plot frames in space
        dibujarsistemaref(TkeyPlane_m,'b_p',1000,1,10,'b')%(T,ind,scale,width,fs,fc)
        % plot point cloud
        dibujarsistemaref(Tkeybox_m,'b',1000,1,10,'b')
        dibujarsistemaref(eye(4),'m',1000,1,10,'b')
    %     dibujarsistemaref(Tc_m,'c',1000,1,10,'b')
        grid on
        xlabel 'x'
        ylabel 'y'
        zlabel 'z'
        title (['Poses of boxes and frames in m world. e_r(' num2str(ers,'%.1f') ' deg), e_t(' num2str(ets,'%.1f') ' mm)'])
        hold off


