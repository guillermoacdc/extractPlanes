clc
close all
clear all


% load length
sessionID=1;
dataSetPath = computeMainPaths(sessionID);
pps=getPPS(dataSetPath, sessionID,1);
boxLengths = loadLengths_v2(dataSetPath,pps(2));
boxID=boxLengths(1);
planeLengths=boxLengths(2:end);

theta_v=[0.1:0.1:1]';
th_eR=5;%deg
th_et=50;%mm
tao=50;
NpointsDiagPpal=20;
% create plane structs with fields L1, L2, H, tform
plane_gt=const_structPlane(planeLengths, eye(4));
Pest=eye(4);

% Pest(1,4)=th_et;%offset in x
% Pest(1:3,1:3)=rotz(th_eR);%rotation in z

Pest(3,4)=th_et;%offset in z
Pest(1:3,1:3)=rotz(th_eR);%rotation in z

plane_scanned=const_structPlane(planeLengths, Pest);


[pc_gt, pc_scanned, correctness_v] = exploreThForCorrectness(theta_v,...
    plane_gt, plane_scanned, NpointsDiagPpal, tao);

figure,
pcshow(pc_gt)
hold on
myPlotPlaneContourPerpend(plane_gt,'y')
pcshow(pc_scanned)
myPlotPlaneContourPerpend(plane_scanned,'b')
xlabel 'x'
ylabel 'y'
zlabel 'z'
grid
title(['Top Plane in box ' num2str(boxID) '; gt in yellow, scanned in blue'])
hold off

% [theta_v; correctness_v]
T=table(theta_v, correctness_v)

