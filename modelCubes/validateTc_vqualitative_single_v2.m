% script to validate Th_c and Tm_c
clc
close all
clear

% set parameters
rootPath="C:\lib\boxTrackinPCs\";
scene=5;%
frame=5;

%% load point cloud from frame
% load point cloud in h
pc_h=loadPointCloud(rootPath,scene, frame);%length in mm
keyframes=loadKeyFrames(rootPath,scene);
Tm_c5=loadTm_c(rootPath,scene,frame);
Th_c5=loadTh_c(rootPath,scene,frame);

axisT=[-2000 2500 -5000 8000 -1000 2000];
figure,
for i=1:length(keyframes)
    frame=keyframes(i);
    %% compute Tm_h
    % load Th_c, Tm_c
    Th_c=loadTh_c(rootPath,scene,frame);
    Tm_c=loadTm_c(rootPath,scene,frame);
    
    % compute Tm_h
        Tm_h=Tm_c*inv(Th_c);
    
    % transform point cloud to mocap framework
    pc_m=myProjection_v3(pc_h,Tm_h);
    pcshow(pc_m)
    hold on
    dibujarsistemaref(eye(4),'m',1000,1,10,'w');
    dibujarsistemaref(Tm_c5,'c',1000,1,10,'w');
    title (['T computed from frame ' num2str(frame) ', scene ' num2str(scene)])
    xlabel 'x'
    ylabel 'y'
    zlabel 'z'

    view(-45*3,30)
    axis(axisT)
    grid on
    pause(1/3)
    hold off
end
