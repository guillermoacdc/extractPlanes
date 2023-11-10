clc
close all
clear
load matGlobalBoxesFigures_v3.mat


sessionID=10;
NpointsDiagPpal=20;
gridStep=1;

Nb=length(globalBoxes);
figure,
hold on
for i=1:Nb
[pcBox,planeDescriptor] = createSyntehticPCFromDetectedBox(globalBoxes(i),sessionID,...
    NpointsDiagPpal, gridStep);

    pcshow(pcBox)
    myPlotPlaneContour(planeDescriptor(1),'b')
    myPlotPlaneContour(planeDescriptor(2),'b')
    myPlotPlaneContour(planeDescriptor(3),'b')
end