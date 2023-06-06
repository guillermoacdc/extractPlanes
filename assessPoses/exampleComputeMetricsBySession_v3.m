clc
close all
clear


% low occlussion scenes
sessionsID=[ 3	10	12	13	17	19	20	25 27	32	33	35 36 39 45	52	53	54];% 
% sessionsID=[3 10];
AlgorithmIDs=[1 2];
planeType=0;% use 0 for top planes, 1 for planes perpendicular to ground
% parameters
[~,pathToWrite,~] = computeMainPaths(1);
fileName=['metricsForLowOccSessions_planeType' num2str(planeType) '_mean.csv'];

Ns=size(sessionsID,2);
Na=size(AlgorithmIDs,2);

for i=1:Ns
    sessionID=sessionsID(i);
    for j=1:Na
        algorithm=AlgorithmIDs(j);
        disp(['computing metrics in algorithm/session ' num2str(algorithm) '/' num2str(sessionID)  ])
        [precision, recall, f1_score, keyFrames] = computeMetricsBySession(sessionID, ...
            algorithm, planeType);        
%         write to a csv file with option of add elements
        Nkf=length(keyFrames);
        
        precision_mean=mean(precision);
        precision_std=std(precision);
        recall_mean=mean(recall);
        recall_std=std(recall);
        f1score_mean=mean(f1_score);
        f1score_std=std(f1_score);
        NumberOfFrames=Nkf;
        frame_min=min(keyFrames);
        frame_max=max(keyFrames);
        dataTable=table(sessionID, algorithm, precision_mean,...
            precision_std, recall_mean, recall_std, f1score_mean,...
            f1score_std, NumberOfFrames, frame_min, frame_max);
        
        writeFileBySession(0,pathToWrite,fileName,dataTable)%sessionID is fixed to save all data in a single file
    end
end

% sessionID=10;
% algorithm=1;
% [precision_v, recall_v, f1_score_v, keyFrames] = computeMetricsBySession(sessionID,algorithm);