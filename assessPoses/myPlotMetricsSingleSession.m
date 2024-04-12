function myPlotMetricsSingleSession(precision_v, recall_v, keyFrames, alg_vs, sessionID)
%MYPLOTMETRICSSINGLESESSION Summary of this function goes here
%   Detailed explanation goes here
pkflag=alg_vs-1;
precision_mean=mean(precision_v);
precision_std=std(precision_v);
recall_mean=mean(recall_v);
recall_std=std(recall_v);
figure,
% plot recall
subplot(212),...
    stem(keyFrames,recall_v,'r')
    hold on
    plot([keyFrames(1) keyFrames(end)],[recall_mean recall_mean],'k--')
    xlabel 'frame'
    ylabel (['recall with mean/std=' num2str(recall_mean,'%4.2f') '/' num2str(recall_std,'%4.2f') ])
    grid
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
        title (['Algorithm wpk. AUC in session ' num2str(sessionID) ])
    else
        title (['Algorithm woutpk. AUC in session ' num2str(sessionID) ])
    end

end

