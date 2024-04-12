% compute average metrics in the format required by minitab
clc
close all
clear

%% set parameters

sessionsID=[3 10 19 12 25 13 27 17 32 20 35 33 36 39 53 45 54 52];
planeType=0;% use 0 for top planes, 1 for planes perpendicular to ground
pkflag_v=[0 1];%previous knowledge flag. Use 1 to enable previous knowledge
app='_v18';
% [dataSetPath,pathToWrite,~] = computeMainPaths(1,app);
dataSetPath = computeReadPaths(1);
pathToWrite = computeReadWritePaths(app);

outputFileName=['localMetrics_planeType' num2str(planeType) '.csv'];
inputFileName=['localAssessment_planeType' num2str(planeType) '.json'];
% outputFileName=['globalMetrics_planeType' num2str(planeType) '.csv'];
% inputFileName=['globalAssessment_planeType' num2str(planeType) '.json'];
Ns=size(sessionsID,2);
Npk=size(pkflag_v,2);
%% iterative processing over sessions
for i=1:Ns
    sessionID=sessionsID(i);
    [~, fitTh2m] = loadTh2m(dataSetPath,sessionID);
    speed=getSpeedSession(dataSetPath,sessionID);
    %% iterative processing over previous knowledge vector
    for j=1:Npk
        pkflag=pkflag_v(j);
        disp(['Computing metrics in session '  num2str(sessionID)  ])
        [~, meanValues,stdValues, keyFrames, tao] = loadAssessment_counts(inputFileName, sessionID,pkflag, app);
%             precision_v=metrics_v(:,1);
            precision_mean=meanValues(1);
            precision_std=stdValues(1);
%             recall_v=metrics_v(:,2);
            recall_mean=meanValues(2);
            recall_std=stdValues(2);
%             f1score_v=metrics_v(:,3);
            f1score_mean=meanValues(3);
            f1score_std=stdValues(3);


        NumberOfFrames=length(keyFrames);
%         processingTimeByFrame_mean=mean(processingTimeByFrame,"omitnan");
        alg_vs=pkflag+1;
        block=ceil(i/2);
%         create Table
        dataTable=table(speed, alg_vs, block,  precision_mean,...
            precision_std, recall_mean, recall_std, f1score_mean,...
            f1score_std,sessionID, fitTh2m);
%         write to a csv file with option of add elements 
        folderID=0;
        writeFileBySession(folderID,pathToWrite,outputFileName,dataTable)%sessionID is fixed to save all data in a single file
    end
end
