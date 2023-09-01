
clc
close all
clear


% rootPath="G:\Mi unidad\boxesDatabaseSample\";
scene=3;
rootPath=computeMainPaths(scene);
NpointsDiagTopSide=50;
numberOfSides=1;
groundFlag=false;

frameID=1;
planeType=0;

% boxID=[18];%For plottin a subset of boxes, put the boxID that you want to plot
% frames = getTargetFramesFromScene(scene);
% idxBoxes=getIDxBoxes(rootPath,scene, boxID);
idxBoxes=getIDxBoxes(rootPath,scene);


% pps=getPPS(rootPath,scene);
% idxBoxes=1:length(pps);

% boxID=[13 16 18 19 14 15 22 23];
% pps=getPPS(rootPath,scene);
% for i=1:length(boxID)
%     idxBoxes(i)=find(pps==boxID(i));
% end


[pcmodel, planeDescriptor_gt, Nboxes] = generateSyntheticModelForScene(rootPath, ...
    scene,numberOfSides,groundFlag, idxBoxes,frameID, NpointsDiagTopSide, planeType);
% [pcmodel, planeDescriptor_gt, Nboxes] = generateSyntheticModelForScene(rootPath, ...
%     scene,spatialSampling,numberOfSides,groundFlag, idxBoxes,frameID);
% [pcmodel, planeDescriptor_gt, Nboxes] = generateSyntheticModelForScene(rootPath, ...
%     scene,spatialSampling,numberOfSides,groundFlag);

figure,
hold on
pcshow(pcmodel)
for i=1:Nboxes
    boxID=planeDescriptor_gt.fr0.values(i).idBox;
    Tm=planeDescriptor_gt.fr0.values(i).tform;
    dibujarsistemaref(Tm,boxID,150,2,10,'w');
end
T0=eye(4);
dibujarsistemaref(T0,'m',150,2,10,'w');

xlabel 'x'
ylabel 'y'
zlabel 'z'
grid on
title (['synthetic pc from scene' num2str(scene) ])

