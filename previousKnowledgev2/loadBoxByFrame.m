function boxByFrameA = loadBoxByFrame(rootPath,scene)
%LOADBOXBYFRAME Load a matrix with info of target box by frame in the
%sequence: boxID, firstFrame, lastFrame
%   Detailed explanation goes here
fileName=rootPath  + 'corrida' + num2str(scene) + '\HL2\pinhole_projection\boxByFrame.txt';
    boxByFrameT= readtable(fileName);
    boxByFrameA = table2array(boxByFrameT);
end

