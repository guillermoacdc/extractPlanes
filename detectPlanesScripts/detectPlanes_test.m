clc
close all
clear all


% rootPath="C:\lib\boxTrackinPCs\";
rootPath="G:\Mi unidad\boxesDatabaseSample\";
processedPlanesPath='G:\Mi unidad\semestre 9\lowOcclusionScenes_processed';
scene=3;
frame=63;
localPlanes=detectPlanes(rootPath,scene,frame,processedPlanesPath);

figure,
myPlotPlanes_v2(localPlanes,localPlanes.(['fr' num2str(frame)]).acceptedPlanes)
title (['boxes detected in scene/frame ' num2str(scene) '/' num2str(frame)])

return
[fList,pList] = matlab.codetools.requiredFilesAndProducts('detectPlanes_test.m');

N=size(fList,1);
destPath='C:\Users\Acer\Documents\planeExtractor\extractPlanes\evaluatePoseError';
for i=1:N 
    sourcePath=fList{i};
    command=['copy ' sourcePath ' ' destPath];
    [status,cmdout]=system(command)
end



