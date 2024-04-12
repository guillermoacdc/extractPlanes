clc
close all
clear 
%% set parameters
% session ID in alternate sequence of speed: low, high, low, high...
sessionsID=[3 10 19 12 25 13 27 17 32 20 35 33 36 39 53 45 54 52];
% sessionsID=10;
Ns=length(sessionsID);
app='_v18';
pathToWrite = computeReadWritePaths(app);
dataSetPath=computeReadPaths(sessionsID(1));
outputFileName='BoxDetectionMetrics_minitab.csv';
algorithmVersions=[1,2];%woutpk, wpk, respectively

for i=1:Ns
    sessionID=sessionsID(i);
    for j=1:length(algorithmVersions)
        alg_vs=algorithmVersions(j);
        if alg_vs==1
            assessmentFileName='assessmentBoxDetection_pk0.json';
        else
            assessmentFileName='assessmentBoxDetection_pk1.json';
        end
        [precision_v, recall_v, f1score_v, parameters, keyFrames] = computeDetectionMetricsBySession(assessmentFileName,...
            sessionID, app);
%         myPlotMetricsSingleSession(precision_v, recall_v, keyFrames, alg_vs, sessionID);
        precision_mean=mean(precision_v);
        precision_std=std(precision_v);
        recall_mean=mean(recall_v);
        recall_std=std(recall_v);
        f1score_mean=mean(f1score_v);
        f1score_std=std(f1score_v);
        speed=getSpeedSession(dataSetPath,sessionID);
        % create Table
        block=ceil(i/2);
        dataTable=table(speed,  alg_vs, block, precision_mean,...
            precision_std, recall_mean, recall_std, f1score_mean,...
            f1score_std, sessionID);
        % write to a csv file with option of add elements 
        folderID=0;
        writeFileBySession(folderID,pathToWrite,outputFileName,dataTable)%sessionID is fixed to save all data in a single file        
    end
end

