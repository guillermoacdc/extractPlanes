function [HololensTicks discardedInit discardedEnd]=synchInitEndh(rootPath, scene)
%SYNCHINITENDH Cut hololens keyframes to satisfy init and end times in
%synchDescriptors
%   returns a matrix  with N rows and two columns: [timestamp_h, frame_h]

% load frames, raw time stamps for a scene
% relevant_ts=readtable(rootPath + 'scene' + num2str(scene) + '\depth.txt');
relevant_ts=readtable(rootPath + 'corrida' + num2str(scene) + '\HL2\pinhole_projection\depth.txt');
available_ts_hl = table2array(relevant_ts(:,1));
available_ts_hl = uint64(available_ts_hl);%relevant timestamps in ntfs
frames=1:size(available_ts_hl ,1);
HololensTicks=[available_ts_hl frames'];

%load initial, final timestamp, discarded mocap samples at init and at end
% synchDescriptors=importdata(rootPath + 'misc\synchDescriptors_1fps.txt');
% global_init_ts=uint64(str2num(char(synchDescriptors.textdata(scene,4))));
% global_end_ts=uint64(str2num(char(synchDescriptors.textdata(scene,7))));
[global_init_ts,global_end_ts] = computeGlobal_Init_End(rootPath,scene);

% its= datetime(global_init_ts,'ConvertFrom',...
%     'ntfs','Format','yyyy-MM-dd HH:mm:ss.SSS','TimeZone','America/Chicago')
% fts= datetime(global_end_ts,'ConvertFrom',...
%     'ntfs','Format','yyyy-MM-dd HH:mm:ss.SSS','TimeZone','America/Chicago')
% aits = datetime(uint64(HololensTicks(1,2)),'ConvertFrom',...
%     'ntfs','Format','yyyy-MM-dd HH:mm:ss.SSS','TimeZone','America/Chicago')
% afts = datetime(uint64(HololensTicks(end,2)),'ConvertFrom',...
%     'ntfs','Format','yyyy-MM-dd HH:mm:ss.SSS','TimeZone','America/Chicago')


% update available_ts_hl with global_init_ts and global_end_ts
index1 = find(available_ts_hl>=global_init_ts);%index greater than global init
index2 = find(available_ts_hl<=global_end_ts);%index lower than global end
index = intersect( index1,index2 );
HololensTicks = HololensTicks(index,:);
discardedInit=size(available_ts_hl,1)-size(index1,1);
discardedEnd=size(available_ts_hl,1)-size(index2,1);

end

