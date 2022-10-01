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
ph=inv(Tc_h);
% load pmref
pmref=inv(Tc_m);
% transform ph to pm
pm=Tm_h*ph;

[ets,ers] = computeSinglePoseError(pm,pmref);



figure,
    hold on
    % plot frames in space
    dibujarsistemaref(pmref,'c',1000,1,10,'b')%(T,ind,scale,width,fs,fc)
    % plot point cloud
    dibujarsistemaref(pm,'c_p',1000,1,10,'b')
    grid on
    xlabel 'x'
    ylabel 'y'
    zlabel 'z'
    title (['Camera from two references (c) mocap, (c_p)  hololens. Frame ' num2str(frame)])
    hold off

return

% look for the lower projection error
er=[];
et=[];
for i=1:Nf
    frame=keyframes(i);
    Tc_m=loadTm_c(rootPath,scene,frame);
    Tc_h=loadTh_c(rootPath,scene,frame);
    % project Tc_h to qm with Tm_h
    Tprojected=Tm_h*inv(Tc_h);
    [ets,ers] = computeSinglePoseError(Tprojected,Tc_m);
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

return



% validate throw projection of a camera from hololens, in an specific frame.

% load ch, cm
frame=5;
Tc_m=loadTm_c(rootPath,scene,frame);
Tc_h=loadTh_c(rootPath,scene,frame);
% project Tc_h to qm with Tm_h
Tprojected=Tm_h*inv(Tc_h);







% 