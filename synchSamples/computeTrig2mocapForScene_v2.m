% Computes the rig2Mocap file for a single scene. Returns a txt file with N
% rows and 13 columns; where N is the number of frames. Column number one 
% has the ntfs timestamp, the rest of the columns have the components of 
% Trig2Mocap in the sequence,
% r11 r12 r13 px r21 r22 r23 py r31 r32 r33 pz
% Name> computeTrig2mocapForScene
clc
close all
clear all

%% define parameters
scene=51;%
offset=0;
% offset = computeOffsetByScene_resync(scene);

% rootPath="C:\lib\boxTrackinPCs\";
rootPath="G:\Mi unidad\boxesDatabaseSample\";
fileName = ['rig2Mocap_offset'  num2str(offset)  '.txt'];

% fullFilePath=rootPath + 'scene' + num2str(scene) + '\' + fileName;
fullFilePath=rootPath + 'corrida' + num2str(scene) + '\' + fileName;
fs=960;%mocap sampling frequence

%% 1. load times synchronized at init and end
mocapTime=synchInitEndm_v4(rootPath,scene);
[hololensTime, discardedHL2_init discardedHL2_end]=synchInitEndh(rootPath, scene);

%% 2. compute closest index and resample
if discardedHL2_init==0
    closestIndex=computeClosestIndex(hololensTime(:,1)+offset,mocapTime(:,1));
    mocapTimeResample=mocapTime(closestIndex,:);
else
    mocapTimeResample=convertKeyFrameh2MocapTick(hololensTime(:,2),rootPath,scene);
end
% compute difference between closestIndex and hololensTime in seconds
diff_ticks=abs(double(hololensTime(:,1))-double(mocapTimeResample(:,1)));
diff_sec=diff_ticks*1e-7;
% figure,
% subplot(312)
% stem(diff_sec)
% xlabel 'samples'
% ylabel 'time difference (sec)'
% grid on
% axis tight
% title (['Time aprox between mocap and HL2. Scene/offset: ' num2str(scene) '/' num2str(offset) '. Mean=' num2str(mean(diff_sec))])



%% 3. compute Tmc for each keysample in mocap
T=computeTm_c(scene, mocapTimeResample(:,2), rootPath);

% add zeros for non scanned frames
emptyinit_T=zeros(discardedHL2_init,12);
emptyend_T=zeros(discardedHL2_end,12);
T=[emptyinit_T ; T ; emptyend_T];

mocapTimeResample=[zeros(discardedHL2_init,2) ; mocapTimeResample ;...
    zeros(discardedHL2_end,2)];

%% 4. Write results in a text file
fid = fopen( fullFilePath, 'wt' );%object to write a txt file
for i=1:size(T,1)
    fid= myWriteToFile_v2( T(i,:), mocapTimeResample(i,1), fid);
end
fclose(fid);



