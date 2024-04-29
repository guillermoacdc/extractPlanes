function assessment = computeTrackedBoxesMetricsBySession_vrotation(estimatedBoxesFileName, sessionID,...
            tao_rotation, evalPath, visiblePlanesByFrameFileName)
%COMPUTETRACKEDBOXESMETRICSBYSESSION Computes a struct called assessment 
% for each frame. The fields of the struct are TPhl2, TPm, FPhl2, FNm. 
% Each one is a vector with box identifiers

estimatedBoxes=loadEstimationsFile(estimatedBoxesFileName, sessionID, evalPath);
dataSetPath=computeReadPaths(sessionID);
keyFrames=loadKeyFrames(dataSetPath, sessionID);
visibleBoxBySession=computeVisibleBoxesBySession(sessionID,visiblePlanesByFrameFileName);
Nkf=length(keyFrames);
for i=1:Nkf
    frameID=keyFrames(i);
    if frameID==9
        disp('stop')
    end
    myBoxes=estimatedBoxes.(['frame' num2str(frameID)]).values;
    disp (['    assessing tracking in frame ' num2str(frameID)])
    if ~isempty(myBoxes)
        currentBoxes=computeCurrentBoxesByFrame(visibleBoxBySession, frameID, sessionID);
        gtBoxes=loadGTBoxes(sessionID, frameID);
        [TPhl2, TPm, FPhl2, FNm] = computeTrackedBoxes_TPFPFNByFrame_vrotation(myBoxes,...
            currentBoxes, gtBoxes, tao_rotation, sessionID);
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


