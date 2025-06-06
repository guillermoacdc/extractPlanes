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
[tform_gt L1_gt L2_gt]=loadGTData(rootPath, scene, keybox);%length is loaded in mm
T=loadInitialPoseHL2(rootPath,scene);%length is loaded in mm

% keyframes=loadKeyFrames(rootPath,scene);
keyframes=[2:9 20:29 40 41 43:44 53:62];
localPlanes=detectPlanes(rootPath,scene,keyframes);

keyPlaneTwins=trackKeyPlane(keyplaneID,localPlanes,keyframes);

[et, er, eL1 eL2]=computePoseError(localPlanes, keyPlaneTwins, T,...
    tform_gt, L1_gt, L2_gt);

% plot results
figure,
subplot(411),...
    stem(et)
    ylabel 'e_t'
subplot(412),...
    stem(er)
    ylabel 'e_r'
subplot(413),...
    stem(eL1)
    ylabel 'e_{L1}'    
subplot(414),...
    stem(eL2)
    ylabel 'e_{L2}'    


return
    keyframe=20;
    figure,
    myPlotPlanes_v2(localPlanes, localPlanes.(['fr' num2str(keyframe)]).acceptedPlanes)
    title (['accepted planes at frame ' num2str(keyframe)])




