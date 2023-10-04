clc
close all
clear 


sessionID=10;
% frameID=102;
th_distance=40;%mm
dataSetPath=computeMainPaths(sessionID);
keyframes=loadKeyFrames(dataSetPath,sessionID);
frameID=keyframes(50);
[pc_raw, cameraPose]=loadSLAMoutput_v2(sessionID,frameID); %loaded in mm
% project pc_raw to qm
pathTh2m=fullfile(dataSetPath,['session' num2str(sessionID)],'analyzed');
fileName='Th2m.txt';
Th2m_array=load(fullfile(pathTh2m,fileName));
Th2m=assemblyTmatrix(Th2m_array);
% project
pc_m=myProjection_v3(pc_raw,Th2m);


%% delete points that fit with ground plane
[~,inlierIndices,outlierIndices]=pcfitplane(pc_m,th_distance,[0 0 1]);
% delete inliers
    xyz=pc_m.Location;
    xyz(inlierIndices,:)=[];
    pcwoutGround=pointCloud(xyz);
pcwoutGround=pcPaint(pcwoutGround,[255 255 255]);

planeDescriptor_gt = loadGTPlanes(sessionID, frameID);
frameFlag=1;
worldRef='m';
figure,
	myPlotPlanes_Anotation(planeDescriptor_gt, frameFlag, worldRef);
	hold on
	pcshow(pcwoutGround)