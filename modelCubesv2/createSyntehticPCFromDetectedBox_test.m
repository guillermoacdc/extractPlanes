
NpointsDiagPpal=20;
gridStep=1;
[pcBox,planeDescriptor] = createSyntehticPCFromDetectedBox(globalBoxes(1),sessionID,...
    NpointsDiagPpal, gridStep);

figure,
pcshow(pcBox)
hold on
myPlotPlaneContour(planeDescriptor(1),'b')
myPlotPlaneContour(planeDescriptor(2),'b')
myPlotPlaneContour(planeDescriptor(3),'b')
