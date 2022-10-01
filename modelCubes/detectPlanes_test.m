clc
close all
clear all

scene=5;%
frame=5;

rootPath="C:\lib\boxTrackinPCs\";

localPlanes=detectPlanes(rootPath,scene,frame);

figure,
myPlotPlanes_v2(localPlanes,localPlanes.(['fr' num2str(frame)]).acceptedPlanes)
title (['boxes detected in scene/frame ' num2str(scene) '/' num2str(frame)])

return

[fList,pList] = matlab.codetools.requiredFilesAndProducts('detectPlanes_test.m');

N=size(fList,2);
destPath='C:\Users\Acer\Documents\planeExtractor\extractPlanes\evaluatePoseError';
for i=1:N 
    sourcePath=fList{i};
    command=['copy ' sourcePath ' ' destPath];
    [status,cmdout]=system(command)
end



