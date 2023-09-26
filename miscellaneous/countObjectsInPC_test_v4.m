clc
close all
clear

% parameters

sessionID=10;

dataSetPath=computeMainPaths(1);
% kf=loadKeyFrames(dataSetPath,sessionID);
% frameID=kf(14);
frameID=12;%12,101,205

th_angle=45;
epsilon=100;%a neighborhood search radius 10cm for the dataset
minpts=90;% minimum number of neighbors required to identify a core point
th_distance=40;%mm
plotFlag=1;
th_distance2=5000;
% test
[clusterDescriptor, pc_h ]= countObjectsInPC_v7(sessionID, frameID,...
    th_angle, th_distance, th_distance2, epsilon, minpts, plotFlag);
numberOfObjects=length(clusterDescriptor.ID);
% outputs and figures

% plot extracted clusters from  pc_m
Nc=length(clusterDescriptor.ID);

xyz=pc_h.Location;
% reduce the threshold distance to have a better plane model by cluster
th_distance=th_distance/2;%mm
figure,
for i=1:Nc
    indexes=clusterDescriptor.rawIndex{clusterDescriptor.ID(i)};
    pc_temp=pointCloud(xyz(indexes,:));
    pc_geomCenter=mean(pc_temp.Location);
    planeModelTemp=pcfitplane(pc_temp,th_distance);
    clusterDescriptor.planeModel{clusterDescriptor.ID(i)}=[planeModelTemp.Parameters, pc_geomCenter];
    pcshow(pc_temp);
    hold on
end

% cluster to plane object...
% 1. Plane filtering parameters
th_angle=15*pi/180;%radians
th_size=150;%number of points
th_lenght=10*10;%mm 10 cm - Update with tolerance_length; is in a high value (30) to pass most of the planes
th_occlusion=1.4;%
D_Tolerance=0.1*1000;%mm ... 0.1 m
planeFilteringParameters=[th_lenght, th_size, th_angle, th_occlusion, D_Tolerance];


planeObject=cluster2PlaneObject(pc_h,clusterDescriptor,planeFilteringParameters);
planeObjectV=myConvertCellToVector(planeObject);
figure,
    pcshow(pc_h);
    hold on
    myPlotPlanes_Anotation(planeObjectV,0);
title(['Visible lateral planes in frame ' num2str(frameID) ', session ' num2str(sessionID)])
Np=size(planeObjectV,2);
display(['there are ' num2str(Np) '  planes'])

