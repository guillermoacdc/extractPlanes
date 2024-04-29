clc
close all
clear
%% set parameters
NpointsDiagTopSide=60;
gridStep=1;

sessionID=10;
frameID=83;%9, 25, 83, 146,204,366,372
dataSetPath = computeReadPaths(1);
app='_vdebug';
evalPath = computeReadWritePaths(app);
visiblePlanesByFrameFileName="visiblePlanesByFrame.json";
pk=0;
estimationsFileName=['estimatedBoxes_pk' num2str(pk) '.json'];
keyframes=loadKeyFrames(dataSetPath, sessionID);
Nkf=length(keyframes);
visiblePlanes_session=loadVisiblePlanesBySession(visiblePlanesByFrameFileName,sessionID);

%% load gt and estimations
% myBox=estimatedBoxes_frame(3);
% myBox=detectedBox(1,25,100,50,eye(4),[],[0 1 2 3 4]);
% load estimated boxes
estimatedBoxes_session=loadEstimationsFile(estimationsFileName, sessionID, evalPath);
estimatedBoxes_frame=estimatedBoxes_session.(['frame' num2str(frameID)]).values;
gtBoxes_frame=loadGTBoxes(sessionID, frameID);

gtBox=gtBoxes_frame(2);
myBox=estimatedBoxes_frame(3);

% project box pose to qm
myBox=projectBox2qm(myBox,sessionID);
% set sidesID in gt box
% gtBox.sidesID=[0 4 3]';
gtBox.sidesID=adjustBoxSides(myBox);

%% plot gt
flagProject2qm=false;
pc_gt=box2pointCloud(gtBox,NpointsDiagTopSide,gridStep);
pc_estimated=box2pointCloud(myBox,NpointsDiagTopSide,gridStep);
colorpc=[255 255 255];
pc_gt=pcPaint(pc_gt,colorpc);
% A=eye(4);
% A(1:3,1:3)=rotx(-90);
% tform=affinetform3d(A);
% pc_estimated= pctransform(pc_estimated,tform);


figure,
    pcshow(pc_gt)
    hold on
    pcshow(pc_estimated)
%     dibujarsistemaref(planeDescriptor(1).tform,planeDescriptor(1).idBox,100,2,10,'b')
    xlabel 'x'
    ylabel 'y'
    zlabel 'z'

% eADI = compute_eADI(pc_gt,pc_estimated)