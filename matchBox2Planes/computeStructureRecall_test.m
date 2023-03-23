clc
close all
clear

sessionID=3;
tao_v=[10:10:50];
theta_v=[0.1:0.1:0.5];
Ntao=length(tao_v);
% evalPath='G:\Mi unidad\semestre 9\lowOcclusionScenes_processed\evalFolder\';
evalPath='G:\Mi unidad\pruebasUbuntu\evalFolder\';
% compute recall
recall = computeStructureRecall(sessionID,tao_v,theta_v, evalPath);
% compute recall by frame
recallByFrame = computeRecallByFrame(recall);
% compute area under the recall curve for each tao
for i=1:Ntao
    recallByFrame.(['tao' num2str(i)]).AUC=...
        mean(recallByFrame.(['tao' num2str(i)]).values,2)*theta_v(end);
end

figure,
stem(recall.frames,recallByFrame.tao5.AUC)
xlabel ('frames')
ylabel ('AUC recall')
grid on
title (['Performance of method A in session ' num2str(sessionID) ' for tao=50'])

% Some recall by frame figures (6 initial frames, tao=10)

figure,
for k=1:6
    subplot(2,3,k)
        frame=recallByFrame.frames(k)*2;
        rx=recall.theta_v;
        ry=recallByFrame.tao5.values(k,:);
        stem(rx,ry)
        xlabel 'theta';
        ylabel 'recall';
        title (['recall at frame ' num2str(frame)])
        grid on
end

return
% plot planes by frame
frameID=20;
datasetPath="G:\Mi unidad\boxesDatabaseSample\";
detectionsPath='G:\Mi unidad\semestre 9\lowOcclusionScenes_processed';
estimatedPlanes=detectPlanes(datasetPath,sessionID,frameID,detectionsPath);
figure,
myPlotPlanes_v2(estimatedPlanes,estimatedPlanes.(['fr' num2str(frameID)]).acceptedPlanes)
title (['boxes detected in sessionID/frame ' num2str(sessionID) '/' num2str(frameID)])