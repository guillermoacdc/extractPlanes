function [precision_v, recall_v, f1_score_v, keyFrames] = computeMetricsBySession(sessionID,algorithm, planeType)
%COMPUTEMETRICSBYSESSION Summary of this function goes here
%   Detailed explanation goes here
[dataSetPath,evalPath,~] = computeMainPaths(sessionID);
theta=0.5;
tao=50;


fileName=['estimatedPoses_ia' num2str(algorithm) '_planeType' num2str(planeType) '.json'];
%% compute recall by theta for all keyframes
keyFrames=loadKeyFrames(dataSetPath,sessionID);
Nkf=length(keyFrames);

% read json file
estimatedPoses = loadEstimationsFile(fileName,sessionID, evalPath);
%initialize variables
precision_v=zeros(Nkf,1);
recall_v=zeros(Nkf,1);
f1_score_v=zeros(Nkf,1);
for i=1:Nkf
    frameID=keyFrames(i);
    pps=getPPS(dataSetPath,sessionID,frameID);
    % extract estimations of an specific frame
    estimatedPose=estimatedPoses.(['frame' num2str(frameID)]);
        if ~isempty(estimatedPose)
            if planeType==0
                [precision, recall] = computeMetricsByFrame_topPlanes(estimatedPose,theta,tao, pps);
            else
                [precision, recall] = computeMetricsByFrame_lateralPlanes(estimatedPose,theta,tao, pps);
            end
            
        else
            continue
        end
        precision_v(i)=precision;
        recall_v(i)=recall;
%         computing f1score: https://www.v7labs.com/blog/f1-score-guide#:~:text=F1%20score%20is%20a%20machine%20learning%20evaluation%20metric%20that%20measures,prediction%20across%20the%20entire%20dataset.
        if (precision+recall)==0
            f1_score_v(i)=0;
        else
            f1_score_v(i)=2*precision*recall/(precision+recall);
        end
end
end

