% script to validate Th_c and Tm_c
clc
close all
clear

% set parameters

scene=5;%
offset=7569;
% rootPath="C:\lib\boxTrackinPCs\";
rootPath="G:\Mi unidad\boxesDatabaseSample\";

% load keyframes
keyframes=loadKeyFrames(rootPath,scene);
Nfr=size(keyframes,2);

frame=keyframes(1);

%% Tm_c validation
Tm=eye(4);

%% Th_c validation
Th=eye(4);
hlbounds=[-2000 2000 -2000 1000 -4500 1500  ];
mocapbounds=[-1800  500 -2500 2000  0 1700 ];
figure,
% for i=1:size(keyframes,2)
for i=1:size(keyframes,2)
    frame=keyframes(i);
    % compute Th_c
    Tm_c=loadTm_c(rootPath,scene,frame,offset);
    % compute Th_c
    Th_c=loadTh_c(rootPath,scene,frame);
    % plot
    subplot(121),...
    % plot frames in space
    dibujarsistemaref(Tm_c,'c',200,1,10,'b')%(T,ind,scale,width,fs,fc)
    hold on
    % plot point cloud
    dibujarsistemaref(Tm,'m',200,1,10,'b')
    grid on
    xlabel 'x (mm)'
    ylabel 'y (mm)'
    zlabel 'z (mm)'
    axis(mocapbounds);
    title (['Camera pose in frame ' num2str(frame) ' wrt to q_m'])
    hold off

    subplot(122),...
    % plot frames in space
%     hAxis=axes;
    dibujarsistemaref(Th_c,'c',400,1,10,'b')%(T,ind,scale,width,fs,fc)
    hAxis=gca;
    hAxis.ZRuler.FirstCrossoverValue = -2000;
    hAxis.ZRuler.SecondCrossoverValue = 2000; %  taked from https://www.mathworks.com/matlabcentral/answers/386936-change-x-y-z-axes-position-in-a-3d-plot-graph
    hold on
    % plot point cloud
    dibujarsistemaref(Th,'h',500,1,10,'b')
    up_vector=[0 1 0];
    camup(up_vector);
    

%     view (2)
    grid on
    xlabel 'x (mm)'
    ylabel 'y (mm)'
    zlabel 'z (mm)'
    title (['Camera pose in frame ' num2str(frame) ' wrt q_h'])
    axis (hlbounds)
%     view(-74,31)
    hold off
    
%     if frame==56
%         disp('stop the code')
%     end
    pause(1)
end

% plot

% 