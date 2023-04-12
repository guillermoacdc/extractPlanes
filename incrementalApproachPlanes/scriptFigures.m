
figure,
    myPlotPlanes_v3(localPlanes,0);
    title(['local planes in frame ' num2str(frameID)])

figure,
    myPlotPlanes_v3(globalPlanes,0);
    title(['globla planes in frame ' num2str(frameID)])

figure,
    myPlotScannedPCs(globalPlanes,dataSetPath,sessionID)
    hold on
    dibujarsistemaref(eye(4),'m',150,2,10,'w');
    title(['Projected point clouds in frame ' num2str(frameID)])

figure,
myPlotPlanes_v3(globalPlanesPrevious,0);    



