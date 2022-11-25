function [tm,th] = loadCommonFrames(rootPath,scene)
%LOADCOMMONFRAMES Summary of this function goes here
%   Detailed explanation goes here
fileName=rootPath+'misc\commonEventFrames.xlsx';
commonFrames=xlsread(fileName);
idx=find(commonFrames(:,1)==scene);
th=commonFrames(idx,3);
tm=commonFrames(idx,2);
end

