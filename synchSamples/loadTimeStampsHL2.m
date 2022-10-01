function timeStampsHL2_ts_array=loadTimeStampsHL2(pinholeproj_path)
%LOADTIMESTAMPSHL2 Summary of this function goes here
%   Detailed explanation goes here
    timeStampsHL2_ts=readtable([pinholeproj_path + 'depth.txt']);
    timeStampsHL2_ts_array = table2array(timeStampsHL2_ts(:,1));
    timeStampsHL2_ts_array = uint64(timeStampsHL2_ts_array);%relevant timestamps in ntfs
end