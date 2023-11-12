% computes metrics for all keyframes that belong to a session 
% _v2 use a better aproximation of number of annotated objects by HL2
% frame. This impacts the recall
clc
close all
clear
%% parameters

pkflag=1;%1 for Awpk, 0 for Awoutpk 
planeType=0;%0 for top planes, 1 for lateral planes
sessionID=10;
app='_vdebug';
% [dataSetPath,evalPath,PCpath] = computeMainPaths(sessionID, app);
evalPath = computeReadWritePaths(app);
[dataSetPath,PCpath] = computeReadPaths(sessionID);

% inputFileName=['assessment_planeType' num2str(planeType) '.json'];
inputFileName=['assessment_planeType' num2str(planeType) '.json'];
keyFrames=loadKeyFrames(dataSetPath,sessionID);
Nkf=length(keyFrames);
assessment=loadEstimationsFile(inputFileName,sessionID, evalPath);
precision_v=zeros(Nkf,1);
recall_v=zeros(Nkf,1);
f1score_v=zeros(Nkf,1);
%% iterative computation
for i=1:Nkf
    frameID=keyFrames(i);
    cAssessment=assessment.(['frame' num2str(frameID)]);
    [NTP, NFP, NFN]=myCounter(cAssessment, pkflag);
    if NTP==0
        precision_v(i)=0;
        recall_v(i)=0;
        f1score_v(i)=0;
    else
        precision_v(i)=NTP/(NTP+NFP);
        recall_v(i)=NTP/(NTP+NFN);
        f1score_v(i)=2*precision_v(i)*recall_v(i)/(precision_v(i)+recall_v(i));
    end
end


%% compute mean and std values
recall_mean=mean(recall_v);
recall_std=std(recall_v);
precision_mean=mean(precision_v);
precision_std=std(precision_v);
f1score_mean=mean(f1score_v);
f1score_std=std(f1score_v);

tao=assessment.Parameters.tao;
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


    