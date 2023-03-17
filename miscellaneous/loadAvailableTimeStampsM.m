function [availableTimeStamps] = loadAvailableTimeStampsM(rootPath,scene)
%LOADAVAILABLETIMESTAMPSM Summary of this function goes here
%   Detailed explanation goes here
% 1. load init scanning time for mocap
append=computeAppend(scene);
fileName=['corrida' num2str(scene) '-00' num2str(append)];
% jsonpath = fullfile(rootPath + 'scene' + num2str(scene) + '\mocap\',[fileName '.rpd.json']);
jsonpath = fullfile(rootPath + 'corrida' + num2str(scene) + '\mocap\',[fileName '.rpd.json']);

fid = fopen(jsonpath); 
raw = fread(fid,inf); 
str = char(raw'); 
fclose(fid); 
val = jsondecode(str);
Nframes=val.frames;

% 2. computes a tick value for each mocap sample considering: 
%   (a) init scanning time for mocap
%   (b) fs=694Hz
%   (c) ntfs ticks

% estimate init scanning time based on metadata
% convert initTime to ntfs---   UTC-5h
[offsetH, offsetMin]=computeOffsetSynch_raw(scene);
initTimeM_date=datetime(str2num(val.date(1:4)),...%year
    str2num(val.date(6:7)),str2num(val.date(9:10)),...%month, day
    str2num(val.time(1:2))+offsetH,str2num(val.time(4:5))+offsetMin,...%hour+5, min--convertion to UTC
    str2num(val.time(7:8)));%sec
initTimeM_ntfs=convertTo(initTimeM_date,'ntfs');%132697151357259650
% % validation
% initTimeM_str=datetime(uint64(initTimeM_ntfs),'ConvertFrom',...
%     'ntfs','Format','yyyy-MM-dd HH:mm:ss.SSS');

startScanning_ntfs=initTimeM_ntfs;

stepScanning=1/960;
% transform seconds to ntfs ticks
stepScanning_ntfs=stepScanning*1e7;

mocapSamples=[1:val.frames];
availableTimeStamps=uint64(zeros(val.frames,1));
for i=1:val.frames
    availableTimeStamps(i)=startScanning_ntfs+((i-1)*stepScanning_ntfs);
end


end

