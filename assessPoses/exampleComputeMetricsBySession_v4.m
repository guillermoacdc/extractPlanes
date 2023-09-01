clc
close all
clear
% _v4: genera salida en el formato requerido por minitab para el análisis
% estadístico de datos

% low occlussion scenes

sessionsID=[3 10 19 12 25 13 27 17 32 20 35 33 36 39 53 45 54 52];
% sessionsID=[3 10 19 12 25  27 17 32 20 35 33 36 39 53 45 54 ];
% sessionsID=36;
algorithm=2;
planeType=0;% use 0 for top planes, 1 for planes perpendicular to ground
pkflag_v=[0 1];%previous knowledge flag. Use 1 to enable previous knowledge
% parameters
[dataSetPath,pathToWrite,~] = computeMainPaths(1);
% pathToWrite= 'G:\Mi unidad\pruebasUbuntu\evalFolder_dmax\evalFolder_dmax3860';

fileName=['metricsForLowOccSessions_planeType' num2str(planeType) '_mean.csv'];

Ns=size(sessionsID,2);
Npk=size(pkflag_v,2);

for i=1:Ns
    sessionID=sessionsID(i);
    [~, fitTh2m] = loadTh2m(dataSetPath,sessionID);
    speed=getSpeedSession(dataSetPath,sessionID);
    for j=1:Npk
        pkflag=pkflag_v(j);
        disp(['computing metrics in algorithm/session ' num2str(algorithm) '/' num2str(sessionID)  ])
        [precision, recall, f1_score, keyFrames, processingTimeByFrame] = computeMetricsBySession(sessionID, ...
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
%         dataTable=table(sessionID, pkflag+1, precision_mean,...
%             precision_std, recall_mean, recall_std, f1score_mean,...
%             f1score_std, NumberOfFrames, frame_min, frame_max, processingTimeByFrame_mean);
        dataTable=table(speed, alg_vs, block,  precision_mean,...
            precision_std, recall_mean, recall_std, f1score_mean,...
            f1score_std,sessionID, fitTh2m);
        
        writeFileBySession(0,pathToWrite,fileName,dataTable)%sessionID is fixed to save all data in a single file
    end
end

% sessionID=10;
% algorithm=1;
% [precision_v, recall_v, f1_score_v, keyFrames] = computeMetricsBySession(sessionID,algorithm);