clc
close all
clear


rootPath="G:\Mi unidad\boxesDatabaseSample\";

spatialSampling=10;
numberOfSides=3;
groundFlag=false;
scene=5;

boxID=[17];%For plotting a subset of boxes, put the boxID that you want to plot
idxBoxes=getIDxBoxes(rootPath,scene, boxID);


[pcmodel, planeDescriptor_gt, Nboxes] = generateSyntheticModelForScene(rootPath, ...
    scene,spatialSampling,numberOfSides,groundFlag, idxBoxes,0);
% load camera pose in an specific frame

frames = getTargetFramesFromScene(scene);
[~ , Tc_h]=loadSLAMoutput(scene,frames(1),rootPath);
% convert Tc from hololens framework to mocap framekork
% Tc_h(1:3,4)=Tc_h(1:3,4)*1000;%convert to mm


pathTmh=['G:\Mi unidad\boxesDatabaseSample\corrida' num2str(scene) '\Th2m.txt'];
Tmh_raw=load(pathTmh);
Tm_h=assemblyTmatrix(Tmh_raw);

Tc_m=Tm_h*Tc_h;
% Tc_m=eye(4);
% Rt=rotx(180)*rotz(-90);%to match with blender camera
% Rt=[1 0 0; 0 1 0; 0 0 -1];
% Tc_m(1:3,1:3)=Tc_m(1:3,1:3)*Rt;
figure,
hold on
pcshow(pcmodel)
boxID=planeDescriptor_gt.fr0.values(idxBoxes).idBox;
Tm=planeDescriptor_gt.fr0.values(idxBoxes).tform;
dibujarsistemaref(Tm,boxID,150,2,10,'w');
T0=eye(4);
dibujarsistemaref(T0,'m',150,2,10,'w');
hold on
dibujarsistemaref(Tc_m,'c',150,2,10,'w');
xlabel 'x'
ylabel 'y'
zlabel 'z'
grid on
title (['3D model for box ' num2str(boxID) ])


% % euler angles box
% box_eul = rotm2eul( Tm(1:3,1:3),'XYZ' )*180;
R=Tc_m(1:3,1:3);
camera_eul = rotm2eul( R,'XYZ' ) * 180
% camera_quat=rotm2quat(R)