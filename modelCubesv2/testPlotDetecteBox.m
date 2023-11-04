clc
close all
clear

% load matGlobalBoxesFigures.mat
load matGlobalBoxesFigures.mat;
sessionID=10;
gridStep=1; 

NpointsDiagTopSide=60;
D=globalBoxes(1).depth;
W=globalBoxes(1).width;

planeDescriptor2=convertBoxIntoPlaneObject(globalBoxes(1), sessionID);

% pc = createSyntheticPCFromDetection(planeDescriptor2,...
%     NpointsDiagTopSide, gridStep, W, D);
% pc=mypc_paint(pc,[255 255 255]);
% figure,
%     pcshow(pc)
% xlabel 'x'
% ylabel 'y'
% zlabel 'z'
% hold on

figure,
myPlotPlaneContour(planeDescriptor2(1),'b');
hold on
myPlotPlaneContour(planeDescriptor2(2),'b');
myPlotPlaneContour(planeDescriptor2(3),'b');

