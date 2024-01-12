function assessment=computeAssessmentBySession_vplaneTracking(estimatedPosesFileName, sessionID,...
        tao, theta, evalPath, visiblePlanesByFrameFileName, planeType, NpointsDiagPpal)
%COMPUTEMETRICSBYSESSION_VBOXDETECTION Computes a struct for each frame.
%The fields of the struct are TPhl2, TPm, FPhl2, FNm. Each one is a vector
%with box identifiers

estimatedPlanes=loadEstimationsFile(estimatedPosesFileName, sessionID, evalPath);
dataSetPath=computeReadPaths(sessionID);
keyFrames=loadKeyFrames(dataSetPath, sessionID);
visiblePlanesBySession = loadVisiblePlanesBySession(visiblePlanesByFrameFileName,sessionID);
Nkf=length(keyFrames);
for i=1:Nkf
    frameID=keyFrames(i);
    if frameID==10
        disp('stop')
    end
    globalPlanes=computeEstimatedGlobalPlanesByType(estimatedPlanes,planeType, frameID);
    disp (['    assessing in frame ' num2str(frameID)])
    if ~isempty(globalPlanes)
%         load gt visible planes by type
        visiblePlanesByFrame=visiblePlanesBySession.(['frame' num2str(frameID)]);
%         if planeType==0
% 
%         else
%             
%         end
        gtVisiblePlanesByFrame=convertVisiblePlanes2PlanesObject(visiblePlanesByFrame,...
            sessionID,frameID);
        
        [TPhl2, TPm, FPhl2, FNm] = computeTPFPFNByFrame_vplaneTracking(globalPlanes,...
            gtVisiblePlanesByFrame, tao, theta, sessionID, NpointsDiagPpal);
%         (globalPlanes,...
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

