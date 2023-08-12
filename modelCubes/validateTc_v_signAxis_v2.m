% script to validate Th_c and Tm_c
clc
close all
clear

% set parameters
scene=5;%
rootPath=computeMainPaths(scene);
% load keyframes
keyframes=loadKeyFrames(rootPath,scene);
Nfr=size(keyframes,2);
frame=keyframes(1);

%% Th_c validation
Th=eye(4);
% load Th_c at frame
% Th_c=loadTh_c(rootPath,scene,frame);
cameraPosePath=fullfile(rootPath, ['session' num2str(scene)],...
    'raw', 'HL2', 'Depth Long Throw_rig2world.txt');
	cameraPoses = myCameraPosesRead(cameraPosePath);%mm
	Th_c=from1DtoTform(cameraPoses(frame,:));
vtest=Th_c(1:3,4);

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