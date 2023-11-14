clc
close all
clear

app='_v16';
sessionID=10;
pkflag=1;%assessmentBoxDetection_pk1
assessmentFileName=['assessmentBoxDetection_pk' num2str(pkflag) '.json'];
[precision_v, recall_v, f1score_v, tao, keyFrames] = computeMetricsBySession_vtemplate(assessmentFileName,...
    sessionID, app);

%% compute mean and std values
recall_mean=mean(recall_v);
recall_std=std(recall_v);
precision_mean=mean(precision_v);
precision_std=std(precision_v);
f1score_mean=mean(f1score_v);
f1score_std=std(f1score_v);

% plot  
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
        title (['Algorithm wpk - top planes. AUC in session ' num2str(sessionID) '. Tao=' num2str(tao) ])
    else
        title (['Algorithm woutpk - top planes. AUC in session ' num2str(sessionID) '. Tao=' num2str(tao) ])
    end