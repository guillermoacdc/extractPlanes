% computes area under the recall curve for all keyframes that belong to a
% session and for a single tao
clc
close all
clear
%% parameters
app='_v18Box';
pkflag=1;
sessionID=3;
% [dataSetPath,evalPath,PCpath] = computeMainPaths(sessionID);
dataSetPath=computeReadPaths(sessionID);
evalPath = computeReadWritePaths(app);
theta=0.5;
tao=50;

assessmentFileName=['assessmentBoxDetection_pk1.json'];
% assessmentFileName=['assessmentBoxTracking_pk1_veADD.json'];
%% compute recall by theta for all keyframes
keyFrames=loadKeyFrames(dataSetPath,sessionID);
Nkf=length(keyFrames);

% read json file
estimatedPoses = loadEstimationsFile(assessmentFileName,sessionID, evalPath);
%initialize variables
% DP_v=zeros(Nkf,Ntheta);
% DPm_v=zeros(Nkf,Ntheta);
precision_v=zeros(Nkf,1);
recall_v=zeros(Nkf,1);

        [precision_v, recall_v, f1score_v, parameters, keyFrames] = computeDetectionMetricsBySession(assessmentFileName,...
            sessionID, app);
%         myPlotMetricsSingleSession(precision_v, recall_v, keyFrames, alg_vs, sessionID);
        precision_mean=mean(precision_v);
        precision_std=std(precision_v);
        recall_mean=mean(recall_v);
        recall_std=std(recall_v);
        f1score_mean=mean(f1score_v);
        f1score_std=std(f1score_v);


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
%     ylim([0 1])
% plot  precision
subplot(211),...
stem(keyFrames,precision_v)
hold on
plot([keyFrames(1) keyFrames(end)],[precision_mean precision_mean],'k--')
    xlabel 'frame'
    ylabel (['precision with mean/std=' num2str(precision_mean,'%4.2f') '/' num2str(precision_std,'%4.2f') ])
    grid
    title (['Algorithm wpk . AUC in session ' num2str(sessionID) '. Tao=' num2str(tao) ])
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
    