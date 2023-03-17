function [pps] = getPPS(rootPath,scene,frame)
%GETPPS_V2 Extracts pps from initialPose1.csv file
%   Detailed explanation goes here

if nargin==2
    frame=1;
end

filename=[rootPath + 'corrida' + num2str(scene) + '\mocap\initialPose1.csv'];
% load initialpose1.csv
pps_t=readtable(filename);
pps_a=table2array(pps_t);
% extract column 1
pps=pps_a(:,1);
% apply unique operator
pps=unique(pps,'stable');

%         update to return a dynamic pps in function of the
%         frame number
boxByFrameA = loadBoxByFrame(rootPath,scene);
indexesBeforeFrame=computeIndexesBeforeFrame(boxByFrameA(:,3), frame);
pps=pps(indexesBeforeFrame:end); 

end

