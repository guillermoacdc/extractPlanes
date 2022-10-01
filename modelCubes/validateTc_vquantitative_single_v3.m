
% script to validate Th_c and Tm_c
clc
close all
clear

%% set parameters
% scene=5;%
% keyboxID=14;%
% frame=5;
% keyplaneID=[frame 2];%

% scene=6;%
% keyboxID=17;%
% frame=66;
% keyplaneID=[frame 2];%

% scene=3;%
% keyboxID=17;%
% frame=130;
% keyplaneID=[frame 2];%
% 
% scene=21;%
% keyboxID=16;%
% frame=35;
% keyplaneID=[frame 7];%

scene=51;%
keyboxID=29;%
frame=29;
keyplaneID=[frame 6];%

% offsetSynch=computeOffsetByScene_resync(scene);
offsetSynch=0;
rootPath="C:\lib\boxTrackinPCs\";

%% load keybox pose in m world
% [Tkeybox_m,~,~]=loadGTData_v2(rootPath, scene, keyboxID);
initialPoses=loadInitialPose_v2(rootPath,scene);
boxLengths = loadLengths(rootPath,scene);
indexKeyBox=find(initialPoses(:,1)==keyboxID);
    Tkeybox_m=assemblyTmatrix(initialPoses(indexKeyBox,[2:13]));
    length=boxLengths(indexKeyBox,[2 3]);
    myGTPlane=createPlaneObject(initialPoses(indexKeyBox,:),length);
    
% [Tkeybox_m,~,~]=loadGTData_v2(rootPath, scene, keyboxID);

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
% load Th_c
    Th_c=loadTh_c(rootPath,scene,frame);
% load Tm_c

    Tm_c=loadTm_c(rootPath,scene,frame,offsetSynch);
% compute Tm_h

    Tm_h=Tm_c*inv(Th_c);
% transform from h to m worlds
pc_m=myProjection_v3(pc_h,Tm_h);    
% compute error of projection    
    Theight=eye(4);
    Theight(1:3,1:3)=[0 1 0 ; 0 0 1 ; 1 0 0];
    TkeyPlane_m=Tm_h*TkeyPlane_h*Theight;
    [ets,ers,et_xyz] = computeSinglePoseError(TkeyPlane_m,Tkeybox_m);
    

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
        myPlotPlaneContourPerpend(myGTPlane)
        % plot frames in space
        dibujarsistemaref(TkeyPlane_m,'b_p',500,1,10,'b')%(T,ind,scale,width,fs,fc)
        % plot point cloud
        dibujarsistemaref(Tkeybox_m,keyboxID,500,1,10,'b')
        dibujarsistemaref(eye(4),'m',1000,1,10,'b')
    %     dibujarsistemaref(Tc_m,'c',1000,1,10,'b')
        grid on
        xlabel 'x (mm)'
        ylabel 'y (mm)'
        zlabel 'z (mm)'
        title (['M-world. e_r(' num2str(ers,'%.1f') ' deg), e_t(' num2str(ets,'%.1f') ' mm): (' num2str(et_xyz','%.1f,') ')'])
        hold off


