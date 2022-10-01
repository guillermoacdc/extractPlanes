clc
close all
clear

markerIDs=[0 3 4 5 6];
rootPath="C:\lib\boxTrackinPCs\";
scene=5;
nmbFrames=loadNumberSamplesMocap(rootPath,scene);
sample=[1:nmbFrames];
position = loadHL2MarkPosAtSample(scene,rootPath,sample);
% [pos_matrix] = myStruct2Matrix(position,markerIDs);
% interpolate by Channel

% test with channel 1
markerID=markerIDs(2);
targetChannel=position.(['M00' num2str(markerID)]);
channelRef=position.M003;

targetChannel_interpolated=manageRigidInterpByChannel(targetChannel,...
    markerID, channelRef,nmbFrames,rootPath,scene);

vectorNaN1=isnan(targetChannel);
vectorNaN2=isnan(targetChannel_interpolated);
vectorNaNRef=isnan(channelRef);
nmbrNaN1=sum(vectorNaN1);
nmbrNaN2=sum(vectorNaN2);


disp(['Number of NaN before/after interpolate: ' num2str(nmbrNaN1(1)) '/' num2str(nmbrNaN2(1))])

boundInit=1;
boundEnd=boundInit+15*960;
pc1=pointCloud(targetChannel(boundInit:boundEnd,:));
pc1_int=pointCloud(targetChannel_interpolated(boundInit:boundEnd,:));
figure,
    subplot(211),...
        pcshow(pc1)
        grid on
        xlabel 'x'
        ylabel 'y'
        zlabel 'z'
        title (['raw marker ' num2str(markerID) ' with NaN length= ' num2str(nmbrNaN1(1))])
    subplot(212),...
        pcshow(pc1_int)
        grid on
        xlabel 'x'
        ylabel 'y'
        zlabel 'z' 
        title (['interpolated marker ' num2str(markerID) ' with NaN length= ' num2str(nmbrNaN2(1))])


% vectorNaN1=isnan(channel1(boundInit:boundEnd,1) );
% vectorNaN2=isnan(channel1_interpolated(boundInit:boundEnd,1));
% % vectorNaNRef=isnan(channelRef);
% nmbrNaN1=sum(vectorNaN1);
% nmbrNaN2=sum(vectorNaN2);