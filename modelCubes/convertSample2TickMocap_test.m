clc
close all
clear

sample=1;
scene=5;
rootPath="C:\lib\boxTrackinPCs\";
fs=960;
ticksPerSec=1e7;
tickValue = convertSample2TickMocap(rootPath,sample,scene,fs,ticksPerSec);

% % validation
initTimeM_str=datetime(uint64(tickValue),'ConvertFrom',...
        'ntfs','Format','yyyy-MM-dd HH:mm:ss.SSS');

sample=2;
tickValue = convertSample2TickMocap(rootPath,sample,scene,fs,ticksPerSec);

% % validation
initTimeM_str=datetime(uint64(tickValue),'ConvertFrom',...
        'ntfs','Format','yyyy-MM-dd HH:mm:ss.SSS');

%% test on convertTick2SampleMocap

sampleE = convertTick2SampleMocap(rootPath,tickValue,scene,fs,ticksPerSec);

