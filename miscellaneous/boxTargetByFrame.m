clc
close all
clear all

datasetPath="G:\Mi unidad\boxesDatabaseSample\";
session=5;
pps=getPPS(datasetPath,session,0);
[NbFrames,boxIDs, initFrame, lastFrame] = readBoxByFrame(datasetPath, session);
targetByFrame=zeros(1,151);
for i=1:length(initFrame)
    targetByFrame(initFrame(i):lastFrame(i))=1*pps(i);
end
figure,
subplot(312),...
stem(targetByFrame)
title ('targets by frame')
xlabel 'frames'
ylabel 'box ID'
grid on