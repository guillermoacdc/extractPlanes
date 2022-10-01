% Computes multiple version of the matrix Trig2mocap, one for each sample
% in the range minSample, maxSample with step steps
% Returns a txt file with the name rig2Mocap_samplex_toy_stepz, where
% x, y, z are init sample, end sample and step, respectively.
% Name> computeTrig2mocap_candidates
clc
close all
clear all


% scene=3;%
% keyframe=130;
% scene=6;%
% keyframe=66;
% scene=5;%
% keyframe=5;
% scene=21;%
% keyframe=35;
scene=51;%
keyframe=29;

rootPath="C:\lib\boxTrackinPCs\";

[mocapTimes,discardedinitMocapSamples,discardedendMocapSamples]=synchInitEndm_v4(rootPath, scene);
[~,discardedinitHSamples,discardedendHSamples]=synchInitEndh(rootPath,scene);
% discardedHL2Samples=loadInitDiscardedSamples(rootPath,scene,'HL2 ');
centralSample=uint64((keyframe-discardedinitHSamples)*(1/4)*960)+discardedinitMocapSamples;
% centralSample=uint64((keyframe)*(1/4)*960)+discardedMocapSamples;
minSample=centralSample-15000;
maxSample=centralSample+15000;%number of samples to consider

if minSample<1
    minSample=1;
end
disp(['candidates at frames [ ' num2str(minSample) ' to ' num2str(maxSample) '] with ' num2str(centralSample) ' as central sample'  ])
return
step=10;%step between samples
fileName = ['rig2Mocap_sample'  num2str(minSample)  '_to' num2str(maxSample)  '_step_'  num2str(step) '.txt'];
fullFilePath=rootPath + 'scene' + num2str(scene) + '\' + fileName;
candidateSamples_m=minSample:step:maxSample;
fs=960;
ticksPerSec=1e7;
candidateTicks = convertSample2TickMocap(rootPath,candidateSamples_m,scene,fs,ticksPerSec);

T=computeTm_c(scene, candidateSamples_m, rootPath);

fid = fopen( fullFilePath, 'wt' );%object to write a txt file
for i=1:length(candidateSamples_m)
    fid= myWriteToFile_v2( T(i,:), candidateTicks(i), fid);
end
fclose(fid);
