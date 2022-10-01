% script to validate Th_c and Tm_c
clc
close all
clear

% set parameters

scene=5;%
rootPath="C:\lib\boxTrackinPCs\";
% load keyframes
keyframes=loadKeyFrames(rootPath,scene);
Nf=size(keyframes,2);
frame=keyframes(4);
% load Th_c, Tm_c
Tc_m=loadTm_c(rootPath,scene,frame);
Tc_h=loadTh_c(rootPath,scene,frame);
% compute Tm_h
Tm_h=inv(Tc_m)*Tc_h;

% load ph
%     detect planes in frame 2
localPlanes=detectPlanes(rootPath,scene,2);
%     extract geometric center of plane 2-3
currentPlane=loadPlanesFromIDs(localPlanes,[2 3]);
ph=currentPlane.tform;
ph(1:3,4)=ph(1:3,4)*1000;
% % ph=inv(Tc_h);

% load pmref
%     load geometric center of box 19 in scene 5
[pmref,~,~]=loadGTData(rootPath, scene, 19);
% % pmref=inv(Tc_m);
% transform ph to pm
pm=Tm_h*ph;

[ets,ers] = computeSinglePoseError(pm,pmref);


