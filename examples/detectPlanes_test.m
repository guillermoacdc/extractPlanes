clc
close all
clear all

% scene=51;%
% frame=6;

scene=5;%
frame=105;

rootPath="C:\lib\boxTrackinPCs\";

localPlanes=detectPlanes(rootPath,scene,frame);
allPlanes=localPlanes.(['fr' num2str(frame)]).acceptedPlanes;
[xzPlanes, xyPlanes, zyPlanes] = extractTypes(localPlanes, allPlanes);
idPlane=3;
Th=eye(4);
Th(1:3,4)=localPlanes.(['fr' num2str(frame)]).values(idPlane).tform(1:3,4);
figure,
myPlotPlanes_v2(localPlanes,xzPlanes, true)
axis square
hold on
dibujarsistemaref(Th,'h',0.1,2,10,'w')
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



