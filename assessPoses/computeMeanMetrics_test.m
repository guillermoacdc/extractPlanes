clc
close all
clear all

sessionID=10;
algorithm=1;
theta=0.5;
tao=50;%mm

[precision1, recall1, keyFrames] = computeMeanMetrics(sessionID,1, theta, tao);
[precision2, recall2] = computeMeanMetrics(sessionID,2, theta, tao);


xmin=keyFrames(1);
xmax=keyFrames(end);
ymin=0;
ymax=1;

% plot  recall
figure,
subplot(211),...
stem(keyFrames,recall1.values)
hold on
plot([keyFrames(1) keyFrames(end)],[recall1.mean recall1.mean],'k--')
    xlabel 'frame'
    ylabel (['Algorithm  1 with mean/std=' num2str(recall1.mean,'%4.2f') '/' num2str(recall1.std,'%4.2f') ])
    grid
    title (['Recall in session ' num2str(sessionID) '. Tao=' num2str(tao) ])
%     axis tight
axis([xmin xmax ymin ymax])

subplot(212),...
stem(keyFrames,recall2.values)
hold on
plot([keyFrames(1) keyFrames(end)],[recall2.mean recall2.mean],'k--')
    xlabel 'frame'
    ylabel (['Algorithm  2 with mean/std=' num2str(recall2.mean,'%4.2f') '/' num2str(recall2.std,'%4.2f') ])
    grid
axis([xmin xmax ymin ymax])
%     axis tight
subplot(212),...
% plot  precision
figure,
subplot(211),...
stem(keyFrames,precision1.values)
hold on
plot([keyFrames(1) keyFrames(end)],[precision1.mean precision1.mean],'k--')
    xlabel 'frame'
    ylabel (['Algorithm  1 with mean/std=' num2str(precision1.mean,'%4.2f') '/' num2str(precision1.std,'%4.2f') ])
    grid
%     axis tight
    axis([xmin xmax ymin ymax])
    title (['Precision in session ' num2str(sessionID) '. Tao=' num2str(tao) ])
subplot(212),...
    stem(keyFrames,precision2.values)
    hold on
    plot([keyFrames(1) keyFrames(end)],[precision2.mean precision2.mean],'k--')
    xlabel 'frame'
    ylabel (['Algorithm 2 with mean/std=' num2str(precision2.mean,'%4.2f') '/' num2str(precision2.std,'%4.2f') ])
    grid
%     axis tight
    axis([xmin xmax ymin ymax])
    