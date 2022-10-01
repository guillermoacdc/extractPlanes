clc 
close all
clear all
% assumptions
% sequence in previousKnowledgeFile.txt corresponds to physical packin
% sequence
% sequence in initialPoseBoxes.csv corresponds to physical packing sequence

rootPath="C:\lib\boxTrackinPCs\";
scene=5;
initialPoses=loadInitialPose_v2(rootPath,scene);
boxLengths = loadLengths(rootPath,scene);


figure,
hold on
for i=1:size(boxLengths,1)
    keyBox=initialPoses(i,1);
    tform_gt=assemblyTmatrix(initialPoses(i,[2:13]));
    length=boxLengths(i,[2 3]);
    myPlanes(i)=createPlaneObject(initialPoses(i,:),length);
    myPlotPlaneContourPerpend(myPlanes(i))
    dibujarsistemaref(tform_gt,keyBox,150,1,10,'black')%(T,ind,scale,width,fs,fc)
end
    dibujarsistemaref(eye(4),'m',1000,1,10,'black')%(T,ind,scale,width,fs,fc)
    grid on 
    xlabel x
    ylabel y
    zlabel z
title (['Boxes distribution in scene ' num2str(scene)])
