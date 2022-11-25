clc
close all
clear
% set parameters
rootPath="C:\lib\boxTrackinPCs\";
scene=6;
boxID=2;
% convert box id to marker id
markerdIDs=box2markerID(scene,rootPath);

markerIDs=[14 16 104 32 40 48 56 64,...
72 81 88 96 24 112 122 128 136 144];
boxesIDs=[13 14 15 16 17 18 19 20 22 23,...
1 2 3 4 9 10 11 12];
index=find(boxesIDs==boxID);


nmbFrames=loadNumberSamplesMocap(rootPath,scene);
sample=[1:nmbFrames];
position = loadHL2MarkPosAtSample(scene,rootPath,sample, markerIDs);

% select one channel
markerID=markerIDs(index);

if markerID>9
    targetChannel=position.(['M0' num2str(markerID)]);
else
    targetChannel=position.(['M00' num2str(markerID)]);
end

boundInit=1;
boundEnd=boundInit+45*960;
pc1=pointCloud(targetChannel(boundInit:boundEnd,:));
figure,
        pcshow(pc1)
        grid on
        xlabel 'x'
        ylabel 'y'
        zlabel 'z'
        title (['raw marker ' num2str(markerID) ' associated with box ' num2str(boxID)])

