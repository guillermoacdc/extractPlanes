
% script to validate Th_c and Tm_c
clc
close all
clear

%% set parameters
scene=5;%
keyboxID=14;%
frame=5;
keyplaneID=[frame 2];%

% scene=3;%
% keyboxID=17;%
% frame=130;
% keyplaneID=[frame 2];%

rootPath="C:\lib\boxTrackinPCs\";

% load keybox pose in m world
[Tkeybox_m,~,~]=loadGTData_v2(rootPath, scene, keyboxID);


%% Perform Tkeyplane  pose estimation in mm
%     detect planes in frame 
localPlanes=detectPlanes(rootPath,scene,frame);

keyPlane=loadPlanesFromIDs(localPlanes,keyplaneID);
TkeyPlane_h_mt=keyPlane.tform;%in mt
TkeyPlane_h=TkeyPlane_h_mt;
TkeyPlane_h(1:3,4)=TkeyPlane_h_mt(1:3,4)*1000;%in mm


% load point cloud of keyplane
pc_h=loadPlanePointCloud(keyPlane.pathPoints);
%% Perform projection into qm and compute pose error
% load Th_c, Tm_c
    Th_c=loadTh_c(rootPath,scene,frame);

    offsetSynch=computeOffsetByScene_resync(scene);
    Tm_c=loadTm_c(rootPath,scene,frame,offsetSynch);
    % compute Tm_h
    Tm_h=Tm_c*inv(Th_c);
    % transform from h to m worlds
    Theight=eye(4);
    Theight(1:3,1:3)=[0 1 0 ; 0 0 1 ; 1 0 0];
    TkeyPlane_m=Tm_h*TkeyPlane_h*Theight;
    [ets,ers,et_xyz] = computeSinglePoseError(TkeyPlane_m,Tkeybox_m);
    pc_m=myProjection_v3(pc_h,Tm_h);

%% plots    
% plot in h world
figure,
    myPlotPlanes_v2(localPlanes, keyplaneID)
    hold on
    dibujarsistemaref(eye(4),'h',1,1,10,'b')
    dibujarsistemaref(TkeyPlane_h_mt,'b_h',1,1,10,'b')
    title 'Pose of box in h-world '
%     camup([0 1 0])
    xlabel 'x (mt)'
    ylabel 'y (mt)'
    zlabel 'z (mt)'


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
        xlabel 'x (mm)'
        ylabel 'y (mm)'
        zlabel 'z (mm)'
        title (['M-world. e_r(' num2str(ers,'%.1f') ' deg), e_t(' num2str(ets,'%.1f') ' mm): (' num2str(et_xyz','%.1f,') ')'])
        hold off


