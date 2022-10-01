% This script measures the error of position and orientation in planes 
% estimations with the pipeline (1). 
% Error metrics. Translation error, Rotation error


clc
close all
clear all

keybox=15;%box selected to measure de pose error
scene=5;%
keyplaneID=[5 3];
rootPath="C:\lib\boxTrackinPCs\";
%% load ground truth of pose
[tform_gt L1ref L2ref]=loadGTData(rootPath, scene, keybox);%length is loaded in mm for tform, in cm for Lx

%% load keyframes and detect planes
keyframes=loadKeyFrames(rootPath,scene);

localPlanes=detectPlanes(rootPath,scene,keyframes);
keyPlaneTwins=trackKeyPlane(keyplaneID,localPlanes,keyframes);
Nt=size(keyPlaneTwins,1);
er=[];
et=[];
eL1=[];
eL2=[];
% compute Tm_h
Tm_h = computeTm_h(rootPath,scene, 5);%length in mm. We have found in frame 5 the most accurate transformation!!

%% compute pose error and length error
for i=1:Nt
    currentTwinID=keyPlaneTwins(i,:);
    currentTwin=loadPlanesFromIDs(localPlanes,currentTwinID);
%     Tm_h = computeTm_h(rootPath,scene, currentTwinID(1));%length in mm
% load Lengths
    L1=currentTwin.L1*100;%cm
    L2=currentTwin.L2*100;%cm
    eL1=[eL1 abs(L1ref-L1)];
    eL2=[eL2 abs(L2ref-L2)];

    Tbox=currentTwin.tform;%distance in mt, angles in rad or degrees
%     conversion to mm
    Tbox_mm=Tbox;
    Tbox_mm(1:3,4)=Tbox_mm(1:3,4)*1000;
    [ets,ers] = computeSinglePoseError(Tm_h*Tbox_mm,tform_gt);
    et=[et ets];%mm
    er=[er ers];
end



% plot results
% plot results

myTickLabels=convertIDsToCell(keyPlaneTwins);
figure,
subplot (211),...
    stem(abs(et-mean(et)))
    xticks([1:Nt])
    xticklabels(myTickLabels)
    xtickangle(90)
    ylabel (['e_t (mm)'])
    grid on
title (['Pose error in scene ' num2str(scene) ...
    '. Keybox= ' num2str(keybox) '. KeyPlane= ' num2str(keyplaneID(1)) '-' num2str(keyplaneID(2)) ])    
subplot (212),...
    stem(abs(er-mean(er)))
    ylabel (['e_r (r) '])
    xticks([1:Nt])
    xticklabels(myTickLabels)
    xtickangle(90)
    xlabel 'frame ID'
    grid on    


return
    keyframe=20;
    figure,
    myPlotPlanes_v2(localPlanes, localPlanes.(['fr' num2str(keyframe)]).acceptedPlanes)
    title (['accepted planes at frame ' num2str(keyframe)])




