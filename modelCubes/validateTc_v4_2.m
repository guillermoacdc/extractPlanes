% script to validate Th_c and Tm_c
clc
close all
clear

% set parameters

scene=5;%
rootPath="C:\lib\boxTrackinPCs\";
frame=4;
%% load point cloud from frame 5
% load point cloud in h
pc_h=loadPointCloud(rootPath,scene, frame);%length in mm

% figure,
% myPlotPlanes_v2(localPlanes,localPlanes.fr5.acceptedPlanes)


%% compute Tm_h
% load Th_c, Tm_c
Tc_m=loadTm_c(rootPath,scene,frame);
Tc_h=loadTh_c(rootPath,scene,frame);
% compute Tm_h
Tm_h=inv(Tc_m)*Tc_h;

% transform point cloud to mocap framework
pc_m=myProjection_v2(pc_h,Tm_h(1:3,1:3),Tm_h(1:3,4));

figure,
pcshow(pc_m)
hold on
% quiver3(gcGround(1),gcGround(2),...
%     gcGround(3),model.Normal(1)*1000,model.Normal(2)*1000,model.Normal(3)*1000,'w')
title 'Projected point cloud'
xlabel 'x'
ylabel 'y'
zlabel 'z'
grid on


