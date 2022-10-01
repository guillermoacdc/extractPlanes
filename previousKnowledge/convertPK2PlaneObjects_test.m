clc
close all
clear all


scene=51;%
rootPath="C:\lib\boxTrackinPCs\";
% load previous knowledge in form of plane objects
planeDescriptor_gt = convertPK2PlaneObjects(rootPath,scene);
%% Generate model points from loaded previous knowledge
frame_gt=0;
% create point clouds from loaded previous knowledge
Nboxes=size(planeDescriptor_gt.fr0.acceptedPlanes,1);
spatialSampling=10;
for i=1:Nboxes
    boxID=planeDescriptor_gt.fr0.values(i).idBox;
    % load height
    H=loadLengths(rootPath,scene);
    H=H(i,4);
    % compute angle btwn axis x (xm,xb)
    T=planeDescriptor_gt.fr0.values(i).tform;
    angle=computeAngleBtwnVectors([1 0 0]',T(1:3,1));
    if(T(2)<0)
        angle=-1*angle;
    end
    disp(['angle btwn box ' num2str(boxID) ' and mocap x frame: ' num2str(angle)])
    
    % load depth, width and height in scene
    L1=planeDescriptor_gt.fr0.values(i).L1;
    L2=planeDescriptor_gt.fr0.values(i).L2;
    pcBox{i}=createSingleBoxPC(L1,L2,H,spatialSampling,angle);
end
% project point clouds with its own Tform
model=[];
for i=1:Nboxes
    T=planeDescriptor_gt.fr0.values(i).tform;
    pcBox_m{i}=myProjection_v3(pcBox{i},T);
    model=[model; pcBox_m{i}.Location];
end
pcmodel=pointCloud(model);
%% plot synthetic point cloud and frames
figure,
pcshow(pcmodel)
hold on 
for i=1:Nboxes
    boxID=planeDescriptor_gt.fr0.values(i).idBox;
    Tm=planeDescriptor_gt.fr0.values(i).tform;
    dibujarsistemaref(Tm,boxID,150,2,10,'w');
end
dibujarsistemaref(eye(4),'m',150,2,10,'w');
xlabel 'x'
ylabel 'y'
zlabel 'z'
grid on
title (['synthetic point cloud from scene ' num2str(scene) ])

return

[fList,pList] = matlab.codetools.requiredFilesAndProducts('convertPK2PlaneObjects_test.m');