
% compute metrics of box detection problem for the dataset
% problem: compute position (3D)  of each box instance in an image. 
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
planeType=1;
NpointsDiagPpal=20;
visiblePlanesByFrameFileName="visiblePlanesByFrame.json";
estimatedPosesFileName='estimatedPlanes_vtest1.json';
outputFileName=['assessment_planeType' num2str(planeType) '.json'];
for i=1:Ns
    sessionID=sessionsID(i);
    evalPath=computeReadWritePaths(app);
    disp (['Assessing plane detection in session ' num2str(sessionID)])
    assessment=computeAssessmentBySession_vplaneTracking(estimatedPosesFileName, sessionID,...
        tao, theta, evalPath, visiblePlanesByFrameFileName, planeType, NpointsDiagPpal);
    assessment.Parameters.tao=tao;
    assessment.Parameters.theta=theta;
    % save result on disk
    mySaveStruct2JSONFile(assessment,outputFileName,evalPath,sessionID);
end

% removing warnings
w = warning('query','last');
id=w.identifier;
warning('off',id)