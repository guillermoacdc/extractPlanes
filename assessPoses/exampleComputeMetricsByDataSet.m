clc
close all
clear

%% set parameters
sessionsID=[3 10 19 12 25 13 27 17 32 20 35 33 36 39 53 45 54 52];
% sessionsID=3;
app='_v16';
pathToWrite = computeReadWritePaths(app);
assessmentFileName=['assessmentBoxDetection_pk1.json'];
outputFileName='metrics_BoxDetection.csv';
%% iterations
Ns=length(sessionsID);
for i=1:Ns
    sessionID=sessionsID(i);
    [precision_v, recall_v, f1score_v, tao, keyFrames] = computeMetricsBySession_vtemplate(assessmentFileName,...
    sessionID, app);
    precision_mean=mean(precision_v);
    precision_std=std(precision_v);

    recall_mean=mean(recall_v);
    recall_std=std(recall_v);

    f1score_mean=mean(f1score_v);
    f1score_std=std(f1score_v);
% create Table
    dataTable=table(sessionID,  precision_mean,...
    precision_std, recall_mean, recall_std, f1score_mean,...
        f1score_std);
% write to a csv file with option of add elements 
        folderID=0;
        writeFileBySession(folderID,pathToWrite,outputFileName,dataTable)%sessionID is fixed to save all data in a single file
end


    