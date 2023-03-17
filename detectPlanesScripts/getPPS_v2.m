function [pps] = getPPS_v2(rootPath,scene)
%GETPPS_V2 Extracts pps from initialPose1.csv file
%   Detailed explanation goes here

filename=[rootPath + 'corrida' + num2str(scene) + '\mocap\initialPose1.csv'];
% load initialpose1.csv
pps_t=readtable(filename);
pps_a=table2array(pps_t);
% extract column 1
pps=pps_a(:,1);
% apply unique operator
pps=unique(pps);
% end
end

