% Computes the rig2Mocap file for a single scene. Returns a txt file with N
% rows and 13 columns; where N is the number of frames. Column number one 
% has the ntfs timestamp, the rest of the columns have the components of 
% Trig2Mocap in the sequence,
% r11 r12 r13 px r21 r22 r23 py r31 r32 r33 pz
% Name> computeTrig2mocapForScene
clc
close all
clear all

% define parameters
scene=21;%
offset=0;
% offset = computeOffsetByScene_resync(scene);

rootPath="C:\lib\boxTrackinPCs\";
fileName = ['rig2Mocap_offset'  num2str(offset)  '.txt'];
fullFilePath=rootPath + 'scene' + num2str(scene) + '\' + fileName;
fs=960;%mocap sampling frequence
% load times synchronized at init and end
mocapTime=synchInitEndm_v4(rootPath,scene);
[hololensTime, discardedHL2_init discardedHL2_end]=synchInitEndh(rootPath, scene);


keyframes=loadAvailableFramesFromHL2(rootPath,scene);
keyframes=keyframes-discardedHL2_init;
index=find(keyframes>0);
keyframes=keyframes(index);

hololensTimeKeyFrames=hololensTime(keyframes,:);

% compute closest index between mocap and hololens
% offset=32393744;

closestIndex=computeClosestIndex(hololensTimeKeyFrames(:,1)+offset,mocapTime(:,1));
mocapTimeResample=mocapTime(closestIndex,:);

% compute Tmc for each keysample in mocap
T=computeTm_c(scene, mocapTimeResample(:,2), rootPath);

% add zeros for non scanned frames
emptyinit_T=zeros(discardedHL2_init,12);
T=[emptyinit_T ; T];
emptyinit_time=zeros(discardedHL2_init,2);
mocapTimeResample=[emptyinit_time ; mocapTimeResample];

return
fid = fopen( fullFilePath, 'wt' );%object to write a txt file
for i=1:size(T,1)
    fid= myWriteToFile_v2( T(i,:), mocapTimeResample(i,1), fid);
end
fclose(fid);



