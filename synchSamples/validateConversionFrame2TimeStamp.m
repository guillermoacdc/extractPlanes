clc
close all
clear


scene=6;%
rootPath="C:\lib\boxTrackinPCs\";

% ts_HL2=loadTimeStampsHL2(rootPath + 'scene' + num2str(scene) + '\');
% 
% ts_HL2_f22=ts_HL2(22);
% 
% mocapTime=synchInitEndm_v4(rootPath,scene);
% 
% closestIndex=computeClosestIndex(ts_HL2_f22,mocapTime(:,1));
% ts_f22=mocapTime(closestIndex,:)
% -------------------

ts_HL2=loadTimeStampsHL2(rootPath + 'scene' + num2str(scene) + '\');

ts_HL2_f22=ts_HL2(29);
ts_HL2_f1=ts_HL2(1);
date22 = datetime(ts_HL2_f22,'ConvertFrom',...
    'ntfs','Format','yyyy-MM-dd HH:mm:ss.SSS','TimeZone','America/Chicago')
date1 = datetime(ts_HL2_f1,'ConvertFrom',...
    'ntfs','Format','yyyy-MM-dd HH:mm:ss.SSS','TimeZone','America/Chicago')
date22-date1
return
mocapTime=synchInitEndm_v4(rootPath,scene);

closestIndex=computeClosestIndex(ts_HL2_f22,mocapTime(:,1));
ts_f22=mocapTime(closestIndex,:)