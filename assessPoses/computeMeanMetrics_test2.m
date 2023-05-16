clc
close all
clear all

% sessionsID=[3	10	12	13	17	19];%	
sessionsID= [20	25	27	32	33	45	52	53	54];
algorithms= [1 2];
theta=0.5;
tao=50;%mm

Ns=size(sessionsID,2);
Na=size(algorithms,2);
for i=1:Ns
    sessionID=sessionsID(i);
    for j=1:Na
        algorithm=algorithms(j);
        [precisionBySession, recallBySession, keyFramesBySession] = computeMeanMetrics(sessionID,algorithm, theta, tao);
        precision_v(i,j)=precisionBySession;
        recall_v(i,j)=recallBySession;
    end
end
T=table(precision_v, recall_v);
[sessionsID', [precision_v(:,1).mean]' [precision_v(:,2).mean]' [recall_v(:,1).mean]' [recall_v(:,2).mean]'];% 
return





% plot  recall
figure,
subplot(211),...
stem(keyFrames,recall.values)
hold on
plot([keyFrames(1) keyFrames(end)],[recall.mean recall.mean],'k--')
    xlabel 'frame'
    ylabel (['recall with mean/std=' num2str(recall.mean,'%4.2f') '/' num2str(recall.std,'%4.2f') ])
    grid
    title (['Algorithm ' num2str(algorithm) '. AUC in session ' num2str(sessionID) '. Tao=' num2str(tao) ])
    axis tight
% plot  precision
subplot(212),...
stem(keyFrames,precision.values)
hold on
plot([keyFrames(1) keyFrames(end)],[precision.mean precision.mean],'k--')
    xlabel 'frame'
    ylabel (['precision with mean/std=' num2str(precision.mean,'%4.2f') '/' num2str(precision.std,'%4.2f') ])
    grid
    axis tight

    