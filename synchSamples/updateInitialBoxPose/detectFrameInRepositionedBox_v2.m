clc
close all
clear
% set parameters
% rootPath="C:\lib\boxTrackinPCs\";
rootPath="G:\Mi unidad\boxesDatabaseSample\";
scene=7;
boxesID=[2 23 22 12 4 11];
% load marker and boxes IDs
[boxesIDs, markerIDs ]=loadBoxesMarkerIDs(scene,rootPath);

% test values for scene 6
% markerIDs=[14 16 104 32 40 48 56 64,...
% 72 81 88 96 24 112 122 128 136 144];
% boxesIDs=[13 14 15 16 17 18 19 20 22 23,...
% 1 2 3 4 9 10 11 12];


nmbFrames=loadNumberSamplesMocap(rootPath,scene);
sample=[1:nmbFrames];
position = loadHL2MarkPosAtSample(scene,rootPath,sample, markerIDs);





for i=1:length(boxesID)
    targetChannel=[];
    % select one channel based on box
    boxID=boxesID(i);
    index=find(boxesIDs==boxID);
    markerID=markerIDs(index);
    
    if numel(num2str(markerID))==1
        targetChannel=position.(['M00' num2str(markerID)]);
    else
        if numel(num2str(markerID))==2
            targetChannel=position.(['M0' num2str(markerID)]);
        else
            targetChannel=position.(['M' num2str(markerID)]);
        end
    end
    
    for i=1:size(targetChannel,1)
        mP(i)=norm(targetChannel(i,:));
    end

    % compute velocity from mP
    mV=diff(mP);
    % compute aceleration from mV
    mA=diff(mV);
    % plot results
    figure,
    subplot(311),...
        plot(mP)
        ylabel '|p|'
        grid on
        axis tight
    title (['Position magnitud associated with box ' num2str(boxID) ' in scene ' num2str(scene)])
    subplot(312),...
        plot(mV)
        ylabel '|v|'
        grid on
        axis tight
    subplot(313),...
        plot(mA)
        ylabel '|a|'
        grid on
        axis tight    
    
end

return
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

