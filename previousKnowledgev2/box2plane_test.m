% clc
% close all
% clear
NpointsDiagTopSide=40;
gridStep=1;
myBox=estimatedBoxes_frame(3);
% myBox=detectedBox(1,25,100,50,eye(4),[],[0 1 2 3 4]);
planeDescriptor = box2planeObject(myBox);
pc=createSyntheticPC_v3(planeDescriptor,NpointsDiagTopSide, gridStep);


figure,
    pcshow(pc)
    hold on
    dibujarsistemaref(planeDescriptor(1).tform,planeDescriptor(1).idBox,100,2,10,'b')
    xlabel 'x'
    ylabel 'y'
    zlabel 'z'