clc 
close all
clear all
% assumptions
% sequence in previousKnowledgeFile.txt corresponds to physical packin
% sequence
% sequence in initialPoseBoxes.csv corresponds to physical packing sequence

rootPath="C:\lib\boxTrackinPCs\";
scene=5;
keybox=14;

initialPoses=loadInitialPose(rootPath,scene);
boxLengths = loadLengths(rootPath,scene);
indexKeyBox=find(initialPoses(:,1)==keybox);
    tform_gt=assemblyTmatrix(initialPoses(indexKeyBox,[2:13]));
    length=boxLengths(indexKeyBox,[2 3]);
    myPlanes=createPlaneObject(initialPoses(indexKeyBox,:),length);

figure,
    myPlotPlaneContourPerpend(myPlanes)
    hold on
    dibujarsistemaref(tform_gt,keybox,150,1,10,'black')%(T,ind,scale,width,fs,fc)
    dibujarsistemaref(eye(4),'m',1000,1,10,'black')%(T,ind,scale,width,fs,fc)
    grid on 
    xlabel x
    ylabel y
    zlabel z
title (['Boxes distribution in scene ' num2str(scene)])
