function [pps] = getPPS(rootPath,scene,frame)
%GETPPS_V2 Extracts pps from boxByFrame file
%   Detailed explanation goes here

if nargin==2
    frame=1;
end

% filename='sessionDescriptor.csv';
% filePath=fullfile(rootPath, ['session' num2str(scene)], 'filtered', 'MoCap');
% % load initialpose1.csv
% pps_t=readtable(fullfile(filePath,filename));
% pps_a=table2array(pps_t);
% % extract column 1
% pps=pps_a(:,1);
% % apply unique operator
% pps=unique(pps,'stable');

%         update to return a dynamic pps in function of the
%         frame number
boxByFrameA = loadBoxByFrame(rootPath,scene);
pps=boxByFrameA(:,1);
indexesBeforeFrame=computeIndexesBeforeFrame(boxByFrameA(:,3), frame);
pps=pps(indexesBeforeFrame:end); 

end

