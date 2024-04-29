% performs a qualitative validation of boxes detected in a single sessión.
% The validation is performed based on a figure

clc
close all
clear

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
% load estimated boxes
estimatedBoxes_session=loadEstimationsFile(estimationsFileName, sessionID, evalPath);
% iterative plotting by frame
fc='b';
linecolor='w';% color for detections

% for i=31:31
%     frameID=keyframes(i);
    estimatedBoxes_frame=estimatedBoxes_session.(['frame' num2str(frameID)]).values;
    gtBoxes_frame=loadGTBoxes(sessionID, frameID);
%     figure,
%     plotDetectdvsGTBoxes(estimatedBoxes_frame, gtBoxes_frame, sessionID);
    figure,
        myPlotBoxContour_v2(estimatedBoxes_frame,sessionID,frameID,fc,linecolor)
% end
% plotDetectdvsGTBoxes(myBoxes,...
%     gtBoxes, sessionID)

