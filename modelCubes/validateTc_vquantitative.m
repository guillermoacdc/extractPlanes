% script to validate Th_c and Tm_c
clc
close all
clear

% set parameters

scene=5;%
rootPath="C:\lib\boxTrackinPCs\";
keyboxID=14;%expected L1(30), L2(40)
keyplaneID=[5 2];%[2 9]
frame=keyplaneID(1);
%load key frames
keyframes=loadKeyFrames(rootPath,scene);
Nf=size(keyframes,2);
% load keybox pose
[Tkeybox_m,~,~]=loadGTData(rootPath, scene, 15);

%% Perform Tkeyplane  pose estimation in mm
%     detect planes in frame 
localPlanes=detectPlanes(rootPath,scene,frame);
%     extract geometric center of plane 
keyPlane=loadPlanesFromIDs(localPlanes,keyplaneID);
TkeyPlane=keyPlane.tform;%in mt
TkeyPlane(1:3,4)=TkeyPlane(1:3,4)*1000;%in mm

%% iterative process
er=[];
et=[];
for i=1:Nf
    frame=keyframes(i);
    % load Th_c, Tm_c
    Th_c=loadTh_c(rootPath,scene,frame);
    Tm_c=loadTm_c(rootPath,scene,frame);
    % compute Tm_h
    Tm_h=Tm_c*inv(Th_c);

    % transform from h to m worlds
    TkeyPlane_m=Tm_h*TkeyPlane;
    [ets,ers] = computeSinglePoseError(TkeyPlane,Tkeybox_m);
    et=[et ets];%mm
    er=[er ers];
end

figure,
subplot (211),...
    stem(et)
%     xticks([1:Nf])
%     xticklabels(myTickLabels)
%     xtickangle(90)
    ylabel (['e_t (mm)'])
    grid on
title (['Pose error in scene ' num2str(scene) ])
%     '. Keybox= ' num2str(keybox) '. KeyPlane= ' num2str(keyplaneID(1)) '-' num2str(keyplaneID(2))     
subplot (212),...
    stem(er)
    ylabel (['e_r (r) '])
%     xticks([1:Nt])
%     xticklabels(myTickLabels)
%     xtickangle(90)
    xlabel 'frame ID'
    grid on 




