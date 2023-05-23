clc
close all
clear




% low occlussion scenes
sessionsID=[3	10	12	13	17	19	20	25	27	32	33	45	52	53	54];% missing: 35 36 39
% sessionsID=[3 10];
AlgorithmIDs=[1 2];
% parameters
[~,pathToWrite,~] = computeMainPaths(1);
fileName='metricsForLowOccSessions.csv';

Ns=size(sessionsID,2);
Na=size(AlgorithmIDs,2);

for i=1:Ns
    sessionID=sessionsID(i);
    for j=1:Na
        algorithm=AlgorithmIDs(j);
        disp(['computing metrics in algorithm/session ' num2str(algorithm) '/' num2str(sessionID)  ])
        [precision, recall, f1_score, keyFrames] = computeMetricsBySession(sessionID, ...
            algorithm);        
%         write to a csv file with option of add elements
        Nkf=length(keyFrames);
        dataTable=table(repmat(sessionID,Nkf,1), repmat(algorithm,Nkf,1), keyFrames', precision, recall, f1_score);
        dataTable.Properties.VariableNames(1)={'sessionID'};
        dataTable.Properties.VariableNames(2)={'algorithm'};
        dataTable.Properties.VariableNames(3)={'frame'};
        writeFileBySession(0,pathToWrite,fileName,dataTable)%sessionID is fixed to save all data in a single file
    end
end

% sessionID=10;
% algorithm=1;
% [precision_v, recall_v, f1_score_v, keyFrames] = computeMetricsBySession(sessionID,algorithm);