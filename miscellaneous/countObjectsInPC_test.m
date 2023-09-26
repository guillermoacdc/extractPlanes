clc
close all
clear

% parameters
typeObject=2;% 1 for top, 2 for perpendicular
sessionID=10;

dataSetPath=computeMainPaths(1);
% kf=loadKeyFrames(dataSetPath,sessionID);
% frameID=kf(14);
frameID=205;%12,101,205

th_angle=45;
epsilon=100;
minpts=90;
th_distance=40;%mm
plotFlag=1;
th_distance2=2000;
% test
[numberOfObjects, clusterDescriptor ]= countObjectsInPC_v6(sessionID, frameID, typeObject,...
    th_angle, th_distance, th_distance2, epsilon, minpts, plotFlag);

% outputs and figures
if typeObject==1
    display(['there are ' num2str(numberOfObjects) ' top planes'])
else
    display(['there are ' num2str(numberOfObjects) ' lateral planes'])
end

% plot extracted clusters from raw pc
Nc=length(clusterDescriptor.ID);
% load pc from session and frame IDs
[pc_raw]=loadSLAMoutput_v2(sessionID,frameID); %loaded in mm
xyz=pc_raw.Location;
figure,
for i=1:Nc
    indexes=clusterDescriptor.rawIndex{clusterDescriptor.ID(i)};
    pc_temp=pointCloud(xyz(indexes,:));
    pcshow(pc_temp);
    hold on
end