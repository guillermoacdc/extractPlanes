function [precision, recall, f1score, tao, keyFrames] = computeMetricsBySession_vtemplate(assessmentFileName, sessionID, app)
%COMPUTEMETRICSBYSESSION_VTEMPLATE Compute metrics for a single session.
%The metrics are composed by vectors of precsion, recall and f1score

evalPath=computeReadWritePaths(app);
dataSetPath = computeReadPaths(sessionID);
keyFrames=loadKeyFrames(dataSetPath,sessionID);
Nkf=length(keyFrames);
assessment=loadEstimationsFile(assessmentFileName,sessionID, evalPath);
% tao=50;
tao=assessment.Parameters.tao;

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

