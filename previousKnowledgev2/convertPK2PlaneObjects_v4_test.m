clc
close all
clear

sessionID=1;
dataSetPath = computeMainPaths(sessionID);
planeType=1;
frameHL2=20;
boxID=17;
spatialSampling=5;
% create plane descriptor
planeDescriptor = convertPK2PlaneObjects_v4(dataSetPath,sessionID,...
    planeType, frameHL2, boxID);

% create point cloud
pc=createPlanePCAtOrigin(planeDescriptor,spatialSampling);
% plot
figure,
pcshow(pc)
hold on
dibujarsistemaref(planeDescriptor.tform, boxID, 150, 2 , 8 , 'w');
hold on
dibujarsistemaref(eye(4),'m',150,2,8,'w')
xlabel 'x'
ylabel 'y'
zlabel 'z'