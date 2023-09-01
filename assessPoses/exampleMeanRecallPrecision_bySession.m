% computes area under the recall curve for all keyframes that belong to a
% session and for a single tao
clc
close all
clear
%% parameters

pkflag=1;
sessionID=12;
[dataSetPath,evalPath,PCpath] = computeMainPaths(sessionID);

algorithm=2;
planeType=0;

theta=0.5;
tao=50;

% fileName=['estimatedPoses_ia' num2str(algorithm) '_planeType' num2str(planeType) '.json'];
fileName=['estimatedPoses_ia_planeType' num2str(planeType) '.json'];

%% compute recall by theta for all keyframes
keyFrames=loadKeyFrames(dataSetPath,sessionID);
Nkf=length(keyFrames);

% read json file
estimatedPoses = loadEstimationsFile(fileName,sessionID, evalPath);
%initialize variables
% DP_v=zeros(Nkf,Ntheta);
% DPm_v=zeros(Nkf,Ntheta);
precision_v=zeros(Nkf,1);
recall_v=zeros(Nkf,1);

for i=1:Nkf
    frameID=keyFrames(i);
    pps=getPPS(dataSetPath,sessionID,frameID);
    % extract estimations of an specific frame
    estimatedPose=estimatedPoses.(['frame' num2str(frameID)]);
    
%         theta=theta_v(j);
        if ~isempty(estimatedPose)
%             [precision, recall] = computeMetricsByFrame_v2(estimatedPose,theta,tao, pps);
            [precision, recall] = computeMetricsByFrame_topPlanes(estimatedPose,theta,tao, pps, pkflag);
        else
            continue
        end
        precision_v(i)=precision;
        recall_v(i)=recall;
    
end

%% compute mean and std values
recall_mean=mean(recall_v);
recall_std=std(recall_v);
precision_mean=mean(precision_v);
precision_std=std(precision_v);

% precision_v=precision_v(246:276);
% recall_v=recall_v(246:276);
% keyFrames=keyFrames(246:276);

% plot  recall
figure,
subplot(212),...
stem(keyFrames,recall_v,'r')
hold on
plot([keyFrames(1) keyFrames(end)],[recall_mean recall_mean],'k--')
    xlabel 'frame'
    ylabel (['recall with mean/std=' num2str(recall_mean,'%4.2f') '/' num2str(recall_std,'%4.2f') ])
    grid
%     axis tight
    xlim('tight')
    ylim([0 1])
% plot  precision
subplot(211),...
stem(keyFrames,precision_v)
hold on
plot([keyFrames(1) keyFrames(end)],[precision_mean precision_mean],'k--')
    xlabel 'frame'
    ylabel (['precision with mean/std=' num2str(precision_mean,'%4.2f') '/' num2str(precision_std,'%4.2f') ])
    grid
    if pkflag==1
        title (['Algorithm wpk' num2str(algorithm) '. AUC in session ' num2str(sessionID) '. Tao=' num2str(tao) ])
    else
        title (['Algorithm woutpk. AUC in session ' num2str(sessionID) '. Tao=' num2str(tao) ])
    end
%     axis tight
    xlim('tight')
    ylim([0 1])


% figure,
% stem(keyFrames,precision_v)
% hold on
% plot([keyFrames(1) keyFrames(end)],[precision_mean precision_mean],'k--')
%     xlabel 'frame'
%     ylabel (['precision with mean/std=' num2str(precision_mean,'%4.2f') '/' num2str(precision_std,'%4.2f') ])
%     grid
%     title (['Precision of algorithm wpk' num2str(algorithm) ' in session ' num2str(sessionID) '. Tao=' num2str(tao) ])
%     axis tight
    