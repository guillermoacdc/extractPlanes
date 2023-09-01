clc
close all
clear 

sessionID=3;
dataSetPath=computeMainPaths(sessionID);
boxID=[19];
% 1 top plane
% 2 front plane
% 3 right plane
% 4 back plane
% 5 left plane
planeType=1;
planeD_top=computePlaneDescriptorsFromBoxID_v2(boxID,sessionID, dataSetPath, 1);
planeD_front=computePlaneDescriptorsFromBoxID_v2(boxID,sessionID, dataSetPath, 2);
planeDescriptor=[planeD_top planeD_front];% planeD_right planeD_back planeD_left];

N=size(planeDescriptor,2);
spatialSampling=5;
initPose_m=loadInitialPose(dataSetPath,sessionID,10);
indexBox=find(initPose_m(:,1)==boxID);
initPose=initPose_m(indexBox,2:end);
Tm2b=assemblyTmatrix(initPose);

figure,
for i=1:N
%     project tform property with tm2b
    planeDescriptor(i).tform=Tm2b*planeDescriptor(i).tform;
    pc=createPlanePCAtOrigin(planeDescriptor(i),spatialSampling);
    pcshow(pc)
    hold on
end

    dibujarsistemaref(planeDescriptor(1).tform, 'top', 150, 2 , 8 , 'w')
    hold on
    dibujarsistemaref(planeDescriptor(2).tform, 'front', 150, 2 , 8 , 'w')
%     dibujarsistemaref(planeDescriptor(3).tform, 'right', 150, 2 , 8 , 'w')
%     dibujarsistemaref(planeDescriptor(4).tform, 'back', 150, 2 , 8 , 'w')
%     dibujarsistemaref(planeDescriptor(5).tform, 'left', 150, 2 , 8 , 'w')
    dibujarsistemaref(eye(4),'m',150,2,8,'w')
    grid
    xlabel 'x'
    ylabel 'y'
    zlabel 'z'