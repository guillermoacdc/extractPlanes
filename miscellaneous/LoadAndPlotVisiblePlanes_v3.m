clc
close all
clear 

% define parameters
sessionID=10;
dataSetPath=computeMainPaths(sessionID);
fileName='visiblePlanesByFrame.json';
keyFrames=loadKeyFrames(dataSetPath, sessionID);
Nkf=length(keyFrames);
% load Th2m
pathTh2m=fullfile(dataSetPath,['session' num2str(sessionID)],'analyzed');
fileNameT='Th2m.txt';
Th2m_array=load(fullfile(pathTh2m,fileNameT));
Th2m=assemblyTmatrix(Th2m_array);

xmin=-2000;
xmax=2500;
ymin=-2000;
ymax=4000;
zmin=-150;
zmax=2500;
mylimits=[xmin, xmax, ymin, ymax, zmin, zmax];
% az=-80;
% elevation=45;
az=-70;
elevation=40;

figure,
for i=1:2:60
    frameID=keyFrames(i);
    %% load visible planes from json file
    visiblePlanesByFrame=loadVisiblePlanes(fileName,sessionID, frameID);
    %% convert visible planes to plane object
    planeDescriptorGTV=convertVisiblePlanes2PlaneObject(visiblePlanesByFrame, sessionID, frameID);
    %% plot visible planes and raw point cloud of the frameID; add coordinate systems
    % load raw point cloud
    [pc_mm, cameraPose]=loadSLAMoutput_v2(sessionID,frameID); 
    % convert pc to qm
    % project points
    pc_m=myProjection_v3(pc_mm,Th2m);
    % project camera pose
    cameraPose_m=Th2m*cameraPose;

        pcshow(pc_m);
        hold on
        myPlotPlanes_Anotation(planeDescriptorGTV,0,'m');
        dibujarsistemaref(cameraPose_m,'h_m', 250, 2, 10, 'w');
        dibujarsistemaref(eye(4),'m',200,2,10,'w');
        title(['Visible gt lateral planes in frame ' num2str(frameID) ', session ' num2str(sessionID) ' qm world'])
        hold off
        view(az, elevation);
        axis(mylimits)
pause;
end
