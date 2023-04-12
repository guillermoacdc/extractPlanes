clc
close all
clear

dataSetPath='D:\6DViCuT_p1';
sessionID=10;
planeType=0;
frameHL2=14;
% boxID=getPPS(dataSetPath,sessionID,frameHL2);
boxID=30;
numberOfSides=3;
NpointsDiagTopSide=100;
rotzValue=180;
% ----
Nb=length(boxID);

%% generation of single boxes
% load descriptors of boxID
planeDescriptor = convertPK2PlaneObjects_v3(dataSetPath,sessionID,planeType, frameHL2, boxID);
% create point cloud of each box ID on qbox
pc_i=createSyntheticPC(planeDescriptor,NpointsDiagTopSide, numberOfSides);
%% projection of each box to their corresponding pose and merge
pc=projectPCtoGTPoses(pc_i,planeDescriptor);

% -------
X=pc.Location(1,1);
Y=pc.Location(1,2);
Z=pc.Location(1,3);
figure,
pcshow(pc)
hold on
dibujarsistemaref(planeDescriptor.fr0.values(1).tform,boxID,150,2,10,'w')
hold on
plot3(X,Y,Z,'yo')
xlabel 'x'
ylabel 'y'
zlabel 'z'
grid on
title 'test on generate synthetic point cloud'

%% rotation of the box in z
T=planeDescriptor.fr0.values(1).tform;
T(1:3,1:3)=rotz(rotzValue)*T(1:3,1:3);
planeDescriptor.fr0.values(1).tform=T;


% create point cloud of each box ID on qbox
pc_i=createSyntheticPC(planeDescriptor,NpointsDiagTopSide, numberOfSides);
%% projection of each box to their corresponding pose and merge
pc=projectPCtoGTPoses(pc_i,planeDescriptor);

% -------
X1=pc.Location(1,1);
Y1=pc.Location(1,2);
Z1=pc.Location(1,3);

X2=pc.Location(50,1);
Y2=pc.Location(50,2);
Z2=pc.Location(50,3);

figure,
pcshow(pc)
hold on
dibujarsistemaref(planeDescriptor.fr0.values(1).tform,boxID,150,2,10,'w')
hold on
plot3(X1,Y1,Z1,'yo',X2,Y2,Z2,'go')
xlabel 'x'
ylabel 'y'
zlabel 'z'
grid on
title 'test on generate synthetic point cloud'
