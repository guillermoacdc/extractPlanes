% script to validate Th_c and Tm_c
clc
close all
clear

% set parameters

scene=5;%
rootPath="C:\lib\boxTrackinPCs\";

% load keyframes
keyframes=loadKeyFrames(rootPath,scene);
Nfr=size(keyframes,2);

frame=keyframes(1);

%% Tm_c validation
Tm=eye(4);
% compute Th_c
Tm_c=loadTm_c(rootPath,scene,frame);
% Ttest=Tm_c;
% Ttest(1:3,4)=[0 0 0]';
vtest=Tm_c(1:3,4);
% plot
figure,
    hold on
    % plot frames in space
    dibujarsistemaref(Tm_c,'c',1000,1,10,'b')%(T,ind,scale,width,fs,fc)
    % plot point cloud
    dibujarsistemaref(Tm,'m',1000,1,10,'b')
%     dibujarsistemaref(Ttest,'c',800,1,10,'b')
    quiver3(0,0,0,vtest(1),vtest(2),vtest(3),'off')
    grid on
    xlabel 'x (mm)'
    ylabel 'y (mm)'
    zlabel 'z (mm)'
    title (['Camera pose in frame ' num2str(frame) ' wrt to q_m'])
    hold off


%% Th_c validation
R=eye(4);
R(1:3,1:3)=rotz(-90);

Th=eye(4);
% compute Th_c
Th_c=loadTh_c(rootPath,scene,frame);

vtest=Th_c(1:3,4);
% Ttest=Th_c;
% Ttest(1:3,4)=[0 0 0]';
% plot
figure,
    hold on
    % plot frames in space
    dibujarsistemaref(Th_c,'c',200,1,10,'b')%(T,ind,scale,width,fs,fc)
    % plot point cloud
    dibujarsistemaref(Th,'h',200,1,10,'b')
%     dibujarsistemaref(Ttest,'c',200,1,10,'b')
    quiver3(0,0,0,vtest(1),vtest(2),vtest(3),'off')
%     camup([0 1 0]);
    grid on
    xlabel 'x (mm)'
    ylabel 'y (mm)'
    zlabel 'z (mm)'
    title (['Camera pose in frame ' num2str(frame) ' wrt q_h'])
    hold off

% 