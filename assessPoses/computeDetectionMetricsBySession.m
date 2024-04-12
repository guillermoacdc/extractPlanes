function [precision, recall, f1score, parameters, keyFrames] = computeDetectionMetricsBySession(assessmentFileName,...
            sessionID, app)
%COMPUTEDETECTIONMETRICSBYSESSION Compute detection metrics for a single session.
%The metrics are composed by vectors of precision, recall and f1score
%   Detailed explanation goes here
evalPath=computeReadWritePaths(app);
dataSetPath = computeReadPaths(sessionID);
keyFrames=loadKeyFrames(dataSetPath,sessionID);
Nkf=length(keyFrames);
assessment=loadEstimationsFile(assessmentFileName,sessionID, evalPath);
parameters=assessment.Parameters;


precision=zeros(Nkf,1);
recall=zeros(Nkf,1);
f1score=zeros(Nkf,1);
for i=1:Nkf
frameID=keyFrames(i);
    assessmentByFrame=assessment.(['frame' num2str(frameID)]);
    [NTP, NFP, NFN]=myCounter(assessmentByFrame, 1);
    if NTP==0
        precision(i)=0;
        recall(i)=0;
        f1score(i)=0;
    else
        precision(i)=NTP/(NTP+NFP);
        recall(i)=NTP/(NTP+NFN);
        f1score(i)=2*precision(i)*recall(i)/(precision(i)+recall(i));
    end
end




end

