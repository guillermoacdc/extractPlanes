function [MocapTimes discardedInit discardedEnd] = synchInitEndm_v4(rootPath,scene)
%SYNCHINITENDM Cut mocap keyframes to satisfy init and end times in
%synchDescriptors
% returns a matrix with Nm rows and two columns: [timestamp_m, samples_m]
% v4. This version computes the startScanning_ntfs using date and time
% fields in the json file that companies the mocap acquisition
% Also, this version CUT the ticks to synch init and end of the
% scanning

% 1. load init scanning time for mocap
append=computeAppend(scene);
fileName=['corrida' num2str(scene) '-00' num2str(append)];
jsonpath = fullfile(rootPath + 'scene' + num2str(scene) + '\mocap\',[fileName '.rpd.json']);

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


%load initial, final timestamp, discarded mocap samples at init and at end
% synchDescriptors=importdata(rootPath + 'misc\synchDescriptors_1fps.txt');
% globalInit=uint64(str2num(char(synchDescriptors.textdata(scene,4))));
% globalEnd=uint64(str2num(char(synchDescriptors.textdata(scene,7))));
[globalInit,globalEnd] = computeGlobal_Init_End(rootPath,scene);


% update relevant_ts_array with globalInit and globalEnd
index1 = find(availableTimeStamps>=globalInit);
index2 = find(availableTimeStamps<=globalEnd);
index = intersect( index1,index2 );
MocapTicks = availableTimeStamps(index,:);
mocapSamples=mocapSamples(:,index);
MocapTimes=[MocapTicks mocapSamples'];
discardedInit=size(availableTimeStamps,1)-size(index1,1);
discardedEnd=size(availableTimeStamps,1)-size(index2,1);
end

