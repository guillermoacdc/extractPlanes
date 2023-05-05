% computes area under the recall curve for all keyframes that belong to a
% session and for a single tao
clc
close all
clear
%% parameters
algorithm=2;
sessionID=10;
[dataSetPath,evalPath,PCpath] = computeMainPaths(sessionID);
theta_v=0.1:0.1:0.5;
Ntheta=length(theta_v);
tao=50;
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
% DP_v=zeros(Nkf,Ntheta);
% DPm_v=zeros(Nkf,Ntheta);
precision_v=zeros(Nkf,Ntheta);
recall_v=zeros(Nkf,Ntheta);

for i=1:Nkf
    frameID=keyFrames(i);
    if frameID==150
        disp('stop from debugger')
    end

    pps=getPPS(dataSetPath,sessionID,frameID);
    % extract estimations of an specific frame
    estimatedPose=estimatedPoses.(['frame' num2str(frameID)]);
    for j=1:Ntheta
        theta=theta_v(j);
        if ~isempty(estimatedPose)
            [precision, recall] = computeMetricsByFrame_v2(estimatedPose,theta,tao, pps);
        else
            continue
        end
%         DP_v(i,j)=DP;
%         DPm_v(i,j)=DPm;
        precision_v(i,j)=precision;
        recall_v(i,j)=recall;
    end
end

%% compute area under recall curve

AUCRecall=max(theta_v)*mean(recall_v,2);%size (Nkf,1)
AUCPrecision=max(theta_v)*mean(precision_v,2);
% plot AUC recall
figure,
subplot(211),...
stem(keyFrames,AUCRecall)
    xlabel 'frame'
    ylabel (['recall with mean/std=' num2str(mean(AUCRecall),'%4.2f') '/' num2str(std(AUCRecall),'%4.2f') ])
    grid
    title (['Algorithm ' num2str(algorithm) '. AUC in session ' num2str(sessionID) '. Tao=' num2str(tao) ])

% plot AUC precision
subplot(212),...
    stem(keyFrames,AUCPrecision)
    xlabel 'frame'
    ylabel (['precision with mean/std=' num2str(mean(AUCPrecision),'%4.2f') '/' num2str(std(AUCPrecision),'%4.2f') ])
    grid
%     title (['Perfomance in session ' num2str(sessionID) '. Tao=' num2str(tao) ])
    