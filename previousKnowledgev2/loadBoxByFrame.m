function boxByFrameA = loadBoxByFrame(rootPath,scene)
%LOADBOXBYFRAME Load a matrix with info of target box by frame in the
%sequence: boxID, firstFrame, lastFrame
%   Detailed explanation goes here
%fileName=rootPath  + 'corrida' + num2str(scene) + '\HL2\pinhole_projection\boxByFrame.txt';
%fileName=rootPath  + 'session'+ num2str(scene) + '/analyzed/HL2/boxByFrame.txt';
fileName='boxByFrame.txt';
filePath=fullfile(rootPath,['session' num2str(scene)], 'analyzed', 'HL2');

boxByFrameT= readtable(fullfile(filePath,fileName));
boxByFrameA = table2array(boxByFrameT);
end

