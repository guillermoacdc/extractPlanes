function [precision, recall, keyFrames] = computeMeanMetrics(sessionID,algorithm, theta, tao)
%COMPUTEMEANMETRICS Computes descriptive statistics of precision and recall
%   precision.mean; saves the mean value
%   precision.std; saves the standard deviation value
%   precision.values; saves the value for each frame
% keyFrames: frames where the operator's view point to the consolidation zone
[dataSetPath,evalPath,~] = computeMainPaths(sessionID);


if algorithm==1
    fileName='estimatedPoses_ia1.json';
else
    fileName='estimatedPoses_ia2.json';
end
%% compute recall by theta for all keyframes
keyFrames=loadKeyFrames(dataSetPath,sessionID);
Nkf=length(keyFrames);

% read json file
estimatedPoses = loadEstimationsFile(fileName,sessionID, evalPath);
%initialize variables
precision_v=zeros(Nkf,1);
recall_v=zeros(Nkf,1);

for i=1:Nkf
    frameID=keyFrames(i);
    pps=getPPS(dataSetPath,sessionID,frameID);
    % extract estimations of an specific frame
    estimatedPose=estimatedPoses.(['frame' num2str(frameID)]);
    
%         theta=theta_v(j);
        if ~isempty(estimatedPose)
            [precisionByFrame, recallByFrame] = computeMetricsByFrame_v2(estimatedPose,theta,tao, pps);
        else
            continue
        end
        precision_v(i)=precisionByFrame;
        recall_v(i)=recallByFrame;
    
end

%% compute mean and std values
recall.mean=mean(recall_v);
recall.std=std(recall_v);
precision.mean=mean(precision_v);
precision.std=std(precision_v);
precision.values=precision_v;
recall.values=recall_v;



end

