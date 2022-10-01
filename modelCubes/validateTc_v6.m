% script to validate Th_c and Tm_c
clc
close all
clear

% set parameters

scene=5;%
rootPath="C:\lib\boxTrackinPCs\";

%% load ph
%     detect planes in frame 5
localPlanes=detectPlanes(rootPath,scene,5);
%     extract geometric center of plane 2-3
currentPlane=loadPlanesFromIDs(localPlanes,[5 3]);
ph=currentPlane.tform;%in mt
ph(1:3,4)=ph(1:3,4)*1000;%in mm

% figure,
% myPlotPlanes_v2(localPlanes,localPlanes.fr5.acceptedPlanes)

%% load pmref
%     load geometric center of box 19 in scene 5
[pmref,~,~]=loadGTData(rootPath, scene, 15);
% % pmref=inv(Tc_m);

%% compute Tm_h
% load Th_c, Tm_c
frame=5;
Tc_m=loadTm_c(rootPath,scene,frame);
Tc_h=loadTh_c(rootPath,scene,frame);
% compute Tm_h
Tm_h=inv(Tc_m)*Tc_h;

% transform ph to pm
pm=Tm_h*ph;
[ets,ers] = computeSinglePoseError(pm,pmref);


figure,
    hold on
    % plot frames in space
    dibujarsistemaref(pm,'b_p',1000,1,10,'b')%(T,ind,scale,width,fs,fc)
    % plot point cloud
    dibujarsistemaref(pmref,'b',1000,1,10,'b')
    dibujarsistemaref(eye(4),'m',1000,1,10,'b')
    dibujarsistemaref(Tc_m,'c',1000,1,10,'b')
    grid on
    xlabel 'x'
    ylabel 'y'
    zlabel 'z'
    title (['Poses of boxes and frames. e_r(' num2str(ers,'%.1f') ' rad), e_t(' num2str(ets,'%.1f') ' mm)'])
    hold off


return

% load keyframes
keyframes=loadKeyFrames(rootPath,scene);
Nf=size(keyframes,2);

er=[];
et=[];
for i=1:Nf
    frame=keyframes(i);
    % load Th_c, Tm_c
    Tc_m=loadTm_c(rootPath,scene,frame);
    Tc_h=loadTh_c(rootPath,scene,frame);
    % compute Tm_h
    Tm_h=inv(Tc_m)*Tc_h;
    % transform ph to pm
    pm=Tm_h*ph;
    [ets,ers] = computeSinglePoseError(pm,pmref);
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



