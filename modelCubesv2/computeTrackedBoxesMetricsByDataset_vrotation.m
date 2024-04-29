clc
close all
clear
% compute the performance of detection problem in the whole dataset

%% set parameters
% sessionsID=[ 3 10	12	13	17	19	20	25 27	32	33	35 36 39 45	52	53	54];% 
sessionsID=10;
dataSetPath = computeReadPaths(1);
app='_v18';
evalPath = computeReadWritePaths(app);
Ns=length(sessionsID);


tao_rotation=15;
% th_r=0.2;%does not need two thresholds for rotatin problem
pkv=[0 1];
visiblePlanesByFrameFileName="visiblePlanesByFrame.json";

for j=1:length(pkv)
    pk=pkv(j);
    estimatedBoxesFileName=['estimatedBoxes_pk' num2str(pk) '.json'];
    outputFileName=['assessmentBoxTracking_pk' num2str(pk) '_rotation.json'];
    for i=1:Ns
        sessionID=sessionsID(i);
        evalPath=computeReadWritePaths(app);
        disp (['Assessing box tracking in session ' num2str(sessionID) 'with pk ' num2str(pk)])
        assessment=computeTrackedBoxesMetricsBySession_vrotation(estimatedBoxesFileName, sessionID,...
            tao_rotation, evalPath, visiblePlanesByFrameFileName);
        tao.rotation=tao_rotation;
        assessment.Parameters.tao=tao;
          % save result on disk
        mySaveStruct2JSONFile(assessment,outputFileName,evalPath,sessionID);
    end
end
% removing warnings
w = warning('query','last');
id=w.identifier;
warning('off',id)
