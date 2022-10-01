% script to validate Th_c and Tm_c
clc
close all
clear

% set parameters

scene=5;%
rootPath="C:\lib\boxTrackinPCs\";
keyboxID=14;%expected L1(30), L2(40)
%load key frames
keyframes=loadKeyFrames(rootPath,scene);
frame=keyframes(4);
band=10000;
scale=100;
Tm_c_candidates=loadTcmCandidates(frame, scene, rootPath, band, scale);

keyplaneID=[frame 2];%[29 4]
Nf=size(keyframes,2);

% load keybox pose in m world
[Tkeybox_m,~,~]=loadGTData(rootPath, scene, 15);


%% Perform Tkeyplane  pose estimation in mm
%     detect planes in frame 
localPlanes=detectPlanes(rootPath,scene,frame);

% figure,
% myPlotPlanes_v2(localPlanes,localPlanes.(['fr' num2str(frame)]).acceptedPlanes);


%     extract pose of plane 
keyPlane=loadPlanesFromIDs(localPlanes,keyplaneID);
TkeyPlane_h=keyPlane.tform;%in mt
TkeyPlane_h(1:3,4)=TkeyPlane_h(1:3,4)*1000;%in mm


NmbCandidates=size(Tm_c_candidates,1);
er=zeros(1,NmbCandidates);
et=zeros(1,NmbCandidates);
Th_c=loadTh_c(rootPath,scene,frame);

Trh=eye(4);
Trh(1:3,1:3)=[1 0 0; 0 -1 0; 0 0 1];

Theight=eye(4);
Theight(1:3,1:3)=[1 0 0; 0 0 1; 0 -1 0];

for i=1:NmbCandidates
    Tm_c=assemblyTmatrix(Tm_c_candidates(i,2:end));
    % compute Tm_h
    Tm_h=Tm_c*Trh*inv(Th_c);
    TkeyPlane_m=Tm_h*TkeyPlane_h*Theight;
    [ets,ers] = computeSinglePoseError(TkeyPlane_m,Tkeybox_m);
    er(i)=ers;
    et(i)=ets;
end

figure,
subplot(211),...
    plot(Tm_c_candidates(:,1),er)
    ylabel 'e_r (deg)'
    grid
title (['Error for a keyplane in frame=' num2str(frame) ', scene=' num2str(scene)  ])
subplot(212),...
    plot(Tm_c_candidates(:,1),et)
    ylabel 'e_t (mm)'
    grid
    xlabel 'time (s)'
axis tight



