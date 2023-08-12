% script to validate Th_c and Tm_c
clc
close all
clear

% set parameters
scene=1;%
rootPath=computeMainPaths(scene);
% load keyframes
keyframes=loadKeyFrames(rootPath,scene);
Nfr=size(keyframes,2);
frame=keyframes(1);

%% Trig2world validation
Trig=eye(4);
cameraPosePath=fullfile(rootPath, ['session' num2str(scene)],...
    'raw', 'HL2', 'Depth Long Throw_rig2world.txt');
	cameraPoses = myCameraPosesRead(cameraPosePath);%mm
	Trig2world=from1DtoTform(cameraPoses(frame,:));
vtest=Trig2world(1:3,4);

figure,
    hold on
    % plot frames in space
    dibujarsistemaref(Trig2world,'world',200,1,10,'b')%(T,ind,scale,width,fs,fc)
    dibujarsistemaref(Trig,'rig',200,1,10,'b')
    quiver3(0,0,0,vtest(1),vtest(2),vtest(3),'off')
%     camup([0 1 0]);
    grid on
    xlabel 'x (mm)'
    ylabel 'y (mm)'
    zlabel 'z (mm)'
    title (['Camera pose in frame ' num2str(frame) ' wrt q_h'])
    axis square
% 