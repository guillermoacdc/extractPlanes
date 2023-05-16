clc
close all
clear 

sessionID=1;
dataSetPath=computeMainPaths(sessionID);
boxID=17;
planeDescriptor=computePlaneDescriptorsFromBoxID(boxID,sessionID, dataSetPath);
N=size(planeDescriptor,2);
spatialSampling=5;
figure,
for i=1:N
    pc=createPlanePCAtOrigin(planeDescriptor(i),spatialSampling);
    pcshow(pc)
    hold on
end

    dibujarsistemaref(planeDescriptor(1).tform, 'top', 150, 2 , 8 , 'w')
    hold on
    dibujarsistemaref(planeDescriptor(2).tform, 'front', 150, 2 , 8 , 'w')
    dibujarsistemaref(planeDescriptor(3).tform, 'right', 150, 2 , 8 , 'w')
    dibujarsistemaref(planeDescriptor(4).tform, 'back', 150, 2 , 8 , 'w')
    dibujarsistemaref(planeDescriptor(5).tform, 'left', 150, 2 , 8 , 'w')
    grid
    xlabel 'x'
    ylabel 'y'
    zlabel 'z'