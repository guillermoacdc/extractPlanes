clc
close all
clear 

%% set parameters
NpointsDiagTopSide=40;
gridStep=1;
tao=33;%mm
th_ADD=0.5;%percent
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
%% load boxes
% load estimated boxes
estimatedBoxes_session=loadEstimationsFile(estimationsFileName, sessionID, evalPath);
estimatedBoxes_frame=estimatedBoxes_session.(['frame' num2str(frameID)]).values;
myBox=estimatedBoxes_frame(1);
% load gt boxes
gtBoxes_frame=loadGTBoxes(sessionID, frameID);
gtBox=gtBoxes_frame(3);
%% adjust boxes to compare
% project estimations from qh to qm
myBox=projectBox2qm(myBox,sessionID);
% adjust sides
% gtBox.sidesID=[0 2 1]';
gtBox.sidesID=adjustBoxSides(myBox);

%% assess poses
eADD=compareBoxes_v1(myBox,gtBox,tao,NpointsDiagTopSide,true);

