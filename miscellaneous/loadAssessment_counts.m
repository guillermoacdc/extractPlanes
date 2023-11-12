function [metrics_v, meanValues,stdValues, keyFrames, tao] = loadAssessment_counts(inputFileName, sessionID,pkflag, app)
%LOADASSESSMENT Loads vector of precision, recall, f1score with values per
%frame, mean values and std values; also loads tao parameter
%   Detailed explanation goes here
% metrics_v=[precision_v,recall_v,f1score_v];
% meanValues=[precision_mean, recall_mean, f1score_mean];
% stdValues=[precision_std, recall_std, f1score_std];


% [dataSetPath,evalPath] = computeMainPaths(sessionID, app);
dataSetPath = computeReadPaths(sessionID);
evalPath=computeReadWritePaths(app);
% inputFileName=['assessment_planeType' num2str(planeType) '.json'];
keyFrames=loadKeyFrames(dataSetPath,sessionID);
Nkf=length(keyFrames);

assessment=loadEstimationsFile(inputFileName,sessionID, evalPath);
precision_v=zeros(Nkf,1);
recall_v=zeros(Nkf,1);
f1score_v=zeros(Nkf,1);
%% iterative computation

for i=1:Nkf
    frameID=keyFrames(i);
    cAssessment=assessment.(['frame' num2str(frameID)]);
    [NTP, NFP, NFN]=myCounter(cAssessment, pkflag);
    if NTP==0
        precision_v(i)=0;
        recall_v(i)=0;
        f1score_v(i)=0;
    else
        precision_v(i)=NTP/(NTP+NFP);
        recall_v(i)=NTP/(NTP+NFN);
        f1score_v(i)=2*precision_v(i)*recall_v(i)/(precision_v(i)+recall_v(i));
    end
end


%% compute mean and std values
recall_mean=mean(recall_v);
recall_std=std(recall_v);
precision_mean=mean(precision_v);
precision_std=std(precision_v);
f1score_mean=mean(f1score_v);
f1score_std=std(f1score_v);

tao=assessment.Parameters.tao;
metrics_v=[precision_v,recall_v,f1score_v];
meanValues=[precision_mean, recall_mean, f1score_mean];
stdValues=[precision_std, recall_std, f1score_std];

end

