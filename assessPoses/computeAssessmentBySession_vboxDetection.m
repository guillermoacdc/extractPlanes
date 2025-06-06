function assessment=computeAssessmentBySession_vboxDetection(estimatedBoxesFileName, sessionID,...
        tao, theta, evalPath, visiblePlanesByFrameFileName)
%COMPUTEMETRICSBYSESSION_VBOXDETECTION Computes a struct for each frame.
%The fields of the struct are TPhl2, TPm, FPhl2, FNm. Each one is a vector
%with box identifiers

estimatedBoxes=loadEstimationsFile(estimatedBoxesFileName, sessionID, evalPath);
dataSetPath=computeReadPaths(sessionID);
keyFrames=loadKeyFrames(dataSetPath, sessionID);
visiblePlanesBySession = loadVisiblePlanesBySession(visiblePlanesByFrameFileName,sessionID);
Nkf=length(keyFrames);
for i=1:Nkf
    frameID=keyFrames(i);
    if frameID==10
        disp('stop')
    end
    myBoxes=estimatedBoxes.(['frame' num2str(frameID)]).values;
    disp (['    assessing in frame ' num2str(frameID)])
    if ~isempty(myBoxes)
        visiblePlanesByFrame=visiblePlanesBySession.(['frame' num2str(frameID)]);
        visibleBoxByFrame=computeVisibleBoxesByFrame(visiblePlanesByFrame);
        gtBoxes=loadGTBoxes(sessionID, frameID);
        [TPhl2, TPm, FPhl2, FNm] = computeTPFPFNByFrame_vboxDetection(myBoxes,...
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

