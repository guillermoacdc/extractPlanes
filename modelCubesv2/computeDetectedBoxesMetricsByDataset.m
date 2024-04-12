clc
close all
clear
% compute the performance of detection problem in the whole dataset

%% set parameters
% sessionsID=[ 3 10	12	13	17	19	20	25 27	32	33	35 36 39 45	52	53	54];% 
sessionsID=13;
dataSetPath = computeReadPaths(1);
app='_v18';
evalPath = computeReadWritePaths(app);
Ns=length(sessionsID);


tao_size=50;
tao_translation=50;
th_d=0.2;%consider using [0.17 , 0.34] 
pkv=[0 1];
visiblePlanesByFrameFileName="visiblePlanesByFrame.json";

for j=1:length(pkv)
    pk=pkv(j);
    estimatedBoxesFileName=['estimatedBoxes_pk' num2str(pk) '.json'];
    outputFileName=['assessmentBoxDetection_pk' num2str(pk) '.json'];
    for i=1:Ns
        sessionID=sessionsID(i);
        evalPath=computeReadWritePaths(app);
        disp (['Assessing box detection in session ' num2str(sessionID) 'with pk ' num2str(pk)])
        assessment=computeDetectedBoxesMetricsBySession(estimatedBoxesFileName, sessionID,...
            tao_size, tao_translation, th_d, evalPath, visiblePlanesByFrameFileName);
        tao.size=tao_size;
        tao.translatio=tao_translation;
        assessment.Parameters.tao=tao;
        assessment.Parameters.th_d=th_d;
        % save result on disk
        mySaveStruct2JSONFile(assessment,outputFileName,evalPath,sessionID);
    end
end
% removing warnings
w = warning('query','last');
id=w.identifier;
warning('off',id)
