function assessment=computeMetricsBySession_vboxDetection(estimatedBoxesFileName, sessionID,...
        tao, theta, evalPath, visiblePlanesByFrameFileName)
%COMPUTEMETRICSBYSESSION_VBOXDETECTION Summary of this function goes here
%   Detailed explanation goes here
% consider update the name with computeAssessmentBySession_vboxDetection

estimatedBoxes=loadEstimationsFile(estimatedBoxesFileName, sessionID, evalPath);
dataSetPath=computeReadPaths(sessionID);
keyFrames=loadKeyFrames(dataSetPath, sessionID);
visiblePlanesBySession = loadVisiblePlanesBySession(visiblePlanesByFrameFileName,sessionID);
Nkf=length(keyFrames);
for i=1:Nkf
    frameID=keyFrames(i);
    myBoxes=estimatedBoxes.(['frame' num2str(frameID)]).values;
    disp (['    assessing in frame ' num2str(frameID)])
    if ~isempty(myBoxes)
        visiblePlanesByFrame=visiblePlanesBySession.(['frame' num2str(frameID)]);
        visibleBoxByFrame=computeVisibleBoxesByFrame(visiblePlanesByFrame);
        gtBoxes=loadGTBoxes(sessionID, frameID);
        [TPhl2, TPm, FPhl2, FNm] = computeMetricsByFrame_vboxDetection(myBoxes,...
            visibleBoxByFrame, gtBoxes, tao, theta, sessionID);
%         (myBoxes,...
%             visibleBoxByFrame, gtBoxes, tao, theta, sessionID)

    else
        TPhl2=[];
        TPm=[];
        FPhl2=[];
        FNm=[];
    end
    assessment.(['frame' num2str(frameID)]).TPhl2=TPhl2;
    assessment.(['frame' num2str(frameID)]).TPm=TPm;
    assessment.(['frame' num2str(frameID)]).FPhl2=FPhl2;
    assessment.(['frame' num2str(frameID)]).FNm=FNm;
end

end

