clc
close all
clear


sessionID=10;
frameID=25;
[~,processedPCsPath]=computeReadPaths(sessionID);
% load raw pc and camera pose
[pc_raw, cameraPose]=loadSLAMoutput_v2(sessionID,frameID); %loaded in mm
% load estimated planes from eRANSAC
% ----
    in_planesFolderPath=fullfile(processedPCsPath,['session' num2str(sessionID)],...
        ['frame' num2str(frameID)] );
    cd1=cd;
    cd(in_planesFolderPath);
    Files1=dir('*.ply');
    cd(cd1);
    numberPlanes=length(Files1);
for i=1:numberPlanes
    planeID=i;
    inliersPath=fullfile(in_planesFolderPath, ['Plane'  num2str(i-1)  'A.ply']);
    [modelParameters, pcCount]=loadPlaneParameters(in_planesFolderPath,... 
        planeID);%modelParameters: normal( A, B, C) distance (D), geometric center (x, y, z) in m
%% 1. Load basic plane descriptors in a cell of plane objects
    planesByFrame{i}=plane(sessionID, frameID, planeID, modelParameters,...
        inliersPath, pcCount);%sessionID,frameID,pID,pnormal,Nmbinliers
%   1.1 identifies and extract ground plane descriptors to use as reference
%   in next steps
    if(planeID==1)%ground plane
        groundNormal=planesByFrame{i}.unitNormal;%warning: could be set as antiparallel
        groundD=abs(planesByFrame{i}.D);
    end
end
% -----
% Plot raw pc and estimated descriptors
figure,
    pcshow(pc_raw)
    hold on
    dibujarsistemaref(cameraPose,'c_h',150,2,10,'w')
    hold on
    dibujarsistemaref(eye(4),'h',150,2,10,'w')
    xlabel 'x'
    ylabel 'y'
    zlabel 'z'
xmin=-4500;
xmax=0;
ymin=-2500;
ymax=0;
zmin=-6000;
zmax=50;
axis([xmin xmax ymin ymax zmin zmax])    

figure,
for i=2:numberPlanes
% for i=8:8
    pathToPlY=planesByFrame{i}.pathPoints;
    n=planesByFrame{i}.unitNormal;
    p=planesByFrame{i}.geometricCenter;
    ptxt=p+350*n;
    txt=num2str(planesByFrame{i}.idPlane);
    pc=myPCread(pathToPlY);
    pcshow(pc)
    hold on
    quiver3(p(1),p(2),p(3),n(1),n(2),n(3),300)
    text(ptxt(1),ptxt(2),ptxt(3),txt,'Color','white','FontSize',14)
end
 dibujarsistemaref(cameraPose,'c_h',150,2,10,'w')
 dibujarsistemaref(eye(4),'h',150,2,10,'w')
 xlabel 'x'
 ylabel 'y'
 zlabel 'z'

%  pc=mypc_paint(pc,[255 255 255]);
%  pcshow(pc,"MarkerSize",15)