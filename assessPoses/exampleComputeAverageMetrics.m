% compute average metrics in the format required by minitab
clc
close all
clear

%% set parameters

sessionsID=[3 10 19 12 25 13 27 17 32 20 35 33 36 39 53 45 54 52];
planeType=1;% use 0 for top planes, 1 for planes perpendicular to ground
pkflag_v=[0 1];%previous knowledge flag. Use 1 to enable previous knowledge
[dataSetPath,pathToWrite,~] = computeMainPaths(1);
outputFileName=['AverageMetricsForLowOccSessions_planeType' num2str(planeType) '.csv'];
inputFileName=['assessment_planeType' num2str(planeType) '.json'];
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
        disp(['computing metrics in algorithm/session ' num2str(algorithm) '/' num2str(sessionID)  ])
        [precision, recall, f1_score, keyFrames] = computeMetricsBySession(sessionID, ...
            algorithm, planeType, pkflag, pathToWrite);        
%         write to a csv file with option of add elements
        Nkf=length(keyFrames);
        processingTimeByFrame_mean=mean(processingTimeByFrame,"omitnan");
        precision_mean=mean(precision);
        precision_std=std(precision);
        recall_mean=mean(recall);
        recall_std=std(recall);
        f1score_mean=mean(f1_score);
        f1score_std=std(f1_score);
        NumberOfFrames=Nkf;
        frame_min=min(keyFrames);
        frame_max=max(keyFrames);
        alg_vs=pkflag+1;
        block=ceil(i/2);
    end
end
