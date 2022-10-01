% script to validate Th_c and Tm_c
clc
close all
clear

% set parameters

scene=5;%
rootPath="C:\lib\boxTrackinPCs\";
%% Tm_c validation

% load keyframes
keyframes=loadKeyFrames(rootPath,scene);
Nfr=size(keyframes,2);
Tm=eye(4);
% iterative
figure,
for i=1:Nfr
% update current frame
    frame=keyframes(i);
% compute Th_c
    Tm_c=loadTm_c(rootPath,scene,frame);
% plot
    hold on
    % plot frames in space
    dibujarsistemaref(Tm_c,'c',1000,1,10,'b')%(T,ind,scale,width,fs,fc)
    % plot point cloud
    dibujarsistemaref(Tm,'m',1000,1,10,'b')
%     camup([0 1 0]);
    grid on
    xlabel 'x'
    ylabel 'y'
    zlabel 'z'
    title (['Trayectory of camera from q_m. Frame ' num2str(frame)])
    hold off

end

return
%% Th_c validation
% load keyframes
keyframes=loadKeyFrames(rootPath,scene);
Nfr=size(keyframes,2);
Th=eye(4);
% iterative
figure,
for i=1:Nfr
% update current frame
    frame=keyframes(i);
% compute Th_c
    Th_c=loadTh_c(rootPath,scene,frame);
% plot
%     pcshow(pc_h);
    hold on
    % plot frames in space
    dibujarsistemaref(Th_c,'c',1000,1,10,'b')%(T,ind,scale,width,fs,fc)
    % plot point cloud
    dibujarsistemaref(Th,'h',1000,1,10,'b')
    camup([0 1 0]);
    grid on
    xlabel 'x'
    ylabel 'y'
    zlabel 'z'
    title (['Trayectory of camera from q_h. Frame ' num2str(frame)])
    hold off

end
% 