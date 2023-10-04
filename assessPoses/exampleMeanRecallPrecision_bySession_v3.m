% computes area under the recall curve for all keyframes that belong to a
% session and for a single tao
% _v2 use a better aproximation of number of annotated objects by HL2
% frame. This impacts the recall
clc
close all
clear
%% parameters

pkflag=1;%1 for Awpk, 0 for Awoutpk 
planeType=0;%0 for top planes, 1 for lateral planes
sessionID=10;
[dataSetPath,evalPath,PCpath] = computeMainPaths(sessionID);

% parameters
theta=0.5;
tao=50;
fileName=['estimatedPoses_ia_planeType' num2str(planeType) '.json'];

%% compute precision and recall

[precision_v, recall_v,~,keyFrames] = computeMetricsBySession(sessionID,...
                    0, planeType, pkflag, evalPath);

%% compute mean and std values
recall_mean=mean(recall_v);
recall_std=std(recall_v);
precision_mean=mean(precision_v);
precision_std=std(precision_v);

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
    xlim('tight')
    ylim([0 1])
    if pkflag==1
        if planeType==0
            title (['Algorithm wpk - top planes. AUC in session ' num2str(sessionID) '. Tao=' num2str(tao) ])
        else
            title (['Algorithm wpk - lateral planes. AUC in session ' num2str(sessionID) '. Tao=' num2str(tao) ])
        end
    else
        if planeType==0
            title (['Algorithm woutpk - top planes. AUC in session ' num2str(sessionID) '. Tao=' num2str(tao) ])
        else
            title (['Algorithm woutpk - lateral planes. AUC in session ' num2str(sessionID) '. Tao=' num2str(tao) ])
        end
    end

% figure,
% stem(keyFrames,precision_v)
% hold on
% plot([keyFrames(1) keyFrames(end)],[precision_mean precision_mean],'k--')
%     xlabel 'frame'
%     ylabel (['precision with mean/std=' num2str(precision_mean,'%4.2f') '/' num2str(precision_std,'%4.2f') ])
%     grid
%     title (['Precision of algorithm wpk' num2str(algorithm) ' in session ' num2str(sessionID) '. Tao=' num2str(tao) ])
%     axis tight
    