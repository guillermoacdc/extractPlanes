
% compute metrics of box detection problem for the dataset
% problem: compute position (3D) and length (h, w, d) of each box instance in an image. 
clc
close all
clear


%% set parameters
% sessionsID=[ 3 10	12	13	17	19	20	25 27	32	33	35 36 39 45	52	53	54];% 
sessionsID=10;
dataSetPath = computeReadPaths(1);
app='_v16';
evalPath = computeReadWritePaths(app);
Ns=length(sessionsID);


tao=50;
theta=0.2;

visiblePlanesByFrameFileName="visiblePlanesByFrame.json";
estimatedPosesFileName='estimatedBoxes_pk1.json';
outputFileName='assessmentBoxDetection_pk1.json';
for i=1:Ns
    sessionID=sessionsID(i);
    evalPath=computeReadWritePaths(app);
    disp (['Assessing box detection in session ' num2str(sessionID)])
    assessment=computeMetricsBySession_vboxDetection(estimatedPosesFileName, sessionID,...
        tao, theta, evalPath, visiblePlanesByFrameFileName);
    % save result on disk
    mySaveStruct2JSONFile(assessment,outputFileName,evalPath,sessionID);
end

% removing warnings
w = warning('query','last');
id=w.identifier;
warning('off',id)