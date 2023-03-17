% This scripts loads and plot an input frame 

clc
close all
clear 

scene=5;%
frame=25;
rootPath="G:\Mi unidad\boxesDatabaseSample";
[pc_mm, Thm]=loadSLAMoutput(scene,frame,rootPath); 
Thf=eye(4);

figure,

pcshow(pc_mm)
camup([0 1 0])
hold on
dibujarsistemaref(Thm,'c_h',0.5,2,10,'k');
dibujarsistemaref(Thf,'h',0.5,2,10,'k');
grid on
xlabel 'x'
ylabel 'y'
zlabel 'z'
title (['pc from scene/frame ' num2str(scene) '/' num2str(frame)])
