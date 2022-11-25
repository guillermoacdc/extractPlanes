% This script creates a point cloud from previous knowledge of a scene
clc
close all
clear


scene=5;

rootPath="C:\lib\boxTrackinPCs\";

%% load previous knowledge in form of plane objects
frame_gt=0;
planeDescriptor_gt = convertPK2PlaneObjects(rootPath,scene);

% figure,
% hold on
% for i=1:size(planeDescriptor_gt.fr0.acceptedPlanes,1)
%     tform_gt=planeDescriptor_gt.fr0.values(i).tform;
%     planeID=planeDescriptor_gt.fr0.values(i).getID;
%     myPlotPlaneContourPerpend(planeDescriptor_gt.fr0.values(i))
%     dibujarsistemaref(tform_gt,planeID,150,1,10,'black')%(T,ind,scale,width,fs,fc)
% end
%     dibujarsistemaref(eye(4),'m',1000,1,10,'black')%(T,ind,scale,width,fs,fc)
%     grid on 
%     xlabel x
%     ylabel y
%     zlabel z
% title (['Boxes distribution in scene ' num2str(scene)])

%% create point clouds from loaded previous knowledge

Nboxes=size(planeDescriptor_gt.fr0.acceptedPlanes,1);
spatialSampling=10;

% heightInScene=planeDescriptor_gt.fr0.values(1).tform(3,4);
for i=1:Nboxes
    % load height
    H=loadLengths(rootPath,scene);
    H=H(i,4);
    % load depth, width and height in scene
    L1=planeDescriptor_gt.fr0.values(i).L1;
    L2=planeDescriptor_gt.fr0.values(i).L2;
    pcBox{i}=createSingleBoxPC_v2(L1,L2,H,spatialSampling);
end

% figure,
% for i=1:Nboxes
%     boxID=planeDescriptor_gt.fr0.values(i).idBox;
%     pcshow(pcBox{i});
%     hold on
%     dibujarsistemaref(eye(4),boxID,150,1,15,'w')
%     hold off
% end
% return

%% project point clouds with its own Tform
for i=1:Nboxes
    T=planeDescriptor_gt.fr0.values(i).tform;
    pcBox_m{i}=myProjection_v3(pcBox{i},T);
end

figure,
for i=1:Nboxes
    boxID=planeDescriptor_gt.fr0.values(i).idBox;
    T=planeDescriptor_gt.fr0.values(i).tform;    
    pcshow(pcBox_m{i});
    hold on
    dibujarsistemaref(T,boxID,150,1,15,'w');    
end
dibujarsistemaref(eye(4),'m',100,1,10,'w')
xlabel 'x'
ylabel 'y'
zlabel 'z'
grid on
title (['ground truth boxes at scene' num2str(scene)])
return
% merge sides into a single pointclud
% pc12=pcmerge(pcSide1,pcSide2,0.001);
% pc34=pcmerge(pcSide3,pcSide4,0.001);
% pc=pcmerge(pc12,pc34,0.001);

% plot
figure,
pcshow(pcTop);
hold on
pcshow(pcSide1);
pcshow(pcSide2);
pcshow(pcSide3);
pcshow(pcSide4);
dibujarsistemaref(eye(4),boxID,100,1,10,'w')
xlabel 'x'
ylabel 'y'
zlabel 'z'
grid on
title (['independent sides of the ground truth box'])
