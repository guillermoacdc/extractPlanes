function [initTimeM_date, initTimeM_ntfs,initTimeH_date,...
    initTimeH_ntfs] = loadInitScanningTime_v2(rootPath,scene,hl2sample,mocapSample)
%LOADINITSCANNINGTIME Summary of this function goes here
%   Detailed explanation goes here
%
%% load init scanning time from mocap
append=computeAppend(scene);
fileName=['corrida' num2str(scene) '-00' num2str(append)];
jsonpath = fullfile(rootPath + 'corrida' + num2str(scene) + '\mocap\',[fileName '.rpd.json']);

fid = fopen(jsonpath); 
raw = fread(fid,inf); 
str = char(raw'); 
fclose(fid); 
val = jsondecode(str);
Nframes=val.frames;

% 2. computes a tick value for each mocap sample considering: 
%   (a) init scanning time for mocap
%   (b) fs=960Hz
%   (c) ntfs ticks

% [offsetH, offsetMin]=computeOffsetSynch_raw(scene);
offsetH=0;
offsetMin=0;
initTimeM_date=datetime(str2num(val.date(1:4)),...%year
    str2num(val.date(6:7)),str2num(val.date(9:10)),...%month, day
    str2num(val.time(1:2))+offsetH,str2num(val.time(4:5))+offsetMin,...%hour+5, min--convertion to UTC
    str2num(val.time(7:8)));%sec
initTimeM_date.TimeZone='America/Chicago';
initTimeM_ntfs=convertTo(initTimeM_date,'ntfs');%132697151357259650
sample_ntfs=uint64(mocapSample*(1e7/960));
initTimeM_ntfs=initTimeM_ntfs+sample_ntfs;
% % validation
% initTimeM_str=datetime(uint64(initTimeM_ntfs),'ConvertFrom',...
%     'ntfs','Format','yyyy-MM-dd HH:mm:ss.SSS');

%% load init scanning time from hl2
initTimeH_ntfs_v = loadAvailableTimeStampsH(rootPath,scene);
initTimeH_ntfs=initTimeH_ntfs_v(hl2sample);
initTimeH_date = datetime(uint64(initTimeH_ntfs),'ConvertFrom',...
    'ntfs','Format','yyyy-MM-dd HH:mm:ss.SSS','TimeZone','America/Chicago');
end

