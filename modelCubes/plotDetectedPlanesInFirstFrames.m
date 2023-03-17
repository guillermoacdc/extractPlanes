clc
close all
clear


% scene=3;
% frame=24;

scene=5;%
frame=5;

% scene=6;
% frame=66;

% scene=21;
% frame=6;

% scene=51;
% frame=29;

% rootPath="C:\lib\boxTrackinPCs\";
rootPath="G:\Mi unidad\boxesDatabaseSample\";
% compute init discarded samples at each sensor
[~,discardedinitHSamples]=synchInitEndh(rootPath, scene);%
[~, discardedinitMocapSamples]=synchInitEndm_v4(rootPath, scene);% 

if frame<discardedinitHSamples 
    disp('Warning. The keyframe is outside the synchronized zone')
end

keyframes=loadKeyFrames(rootPath,scene);

localPlanes=detectPlanes(rootPath,scene,frame);
% % code to recompute the key plane
figure,
myPlotPlanes_v2(localPlanes,localPlanes.(['fr' num2str(frame)]).acceptedPlanes)
title (['boxes detected in scene/frame ' num2str(scene) '/' num2str(frame)])
return