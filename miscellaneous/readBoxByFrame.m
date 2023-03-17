function [NbFrames,boxIDs, initFrame, lastFrame] = readBoxByFrame(rootPath, scene)
%READBOXBYFRAME Summary of this function goes here
%   Detailed explanation goes here
fileName=rootPath  + 'corrida' + num2str(scene) + '\HL2\pinhole_projection\boxByFrame.txt';
fid = fopen( fileName );
% fid = fopen([rootPath '/corrida' num2str(scene) 'HL2/pinhole_projection/boxByFrame.txt' ]);
i=1;
while ~feof(fid)
    tline = fgets(fid);
    if i==1
        NbFrames=str2num(tline);
    else
        descriptor(i-1,1:3)=str2num(tline);    
    end
    
    i=i+1;
end
fclose(fid);
boxIDs=descriptor(:,1);
initFrame=descriptor(:,2);
lastFrame=descriptor(:,3);
end
