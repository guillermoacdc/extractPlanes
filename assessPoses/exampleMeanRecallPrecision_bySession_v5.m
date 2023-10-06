% computes metrics for all keyframes that belong to a session 
% _v2 use a better aproximation of number of annotated objects by HL2
% frame. This impacts the recall
clc
close all
clear
%% parameters

pkflag=1;%1 for Awpk, 0 for Awoutpk 
planeType=0;%0 for top planes, 1 for lateral planes
sessionID=13;
[dataSetPath,evalPath,PCpath] = computeMainPaths(sessionID);
inputFileName=['assessment_planeType' num2str(planeType) '.json'];

[metrics_v, meanValues,stdValues, keyFrames, tao] = loadAssessment_counts(inputFileName, sessionID,pkflag);
precision_v=metrics_v(:,1);
recall_v=metrics_v(:,2);
precision_mean=meanValues(1);
recall_mean=meanValues(2);
precision_std=stdValues(1);
recall_std=stdValues(2);

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


    