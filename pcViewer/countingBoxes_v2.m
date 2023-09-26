% This script count the number of boxes in a point cloud
% assumption: the boxes are not stacked
% the point cloud floor is aligned with plane x-y in qm coordinate system
% _v2: adds the normal vector as a descriptor for the clustering algorithm.
% The output cluster the number of boxes but not differentiates btwn
% lateral and top planes
clc
close all
clear 


sessionID=10;%
% frameID=14;%205
dataSetPath=computeMainPaths(1);
kf=loadKeyFrames(dataSetPath,sessionID);
frameID=kf(20);
%% load point cloud
[pc_mm, Thm]=loadSLAMoutput_v2(sessionID,frameID); 

%% convert pc to qm
% load Th2m
dataSetPath=computeMainPaths(sessionID);
pathTh2m=fullfile(dataSetPath,['session' num2str(sessionID)],'analyzed');
fileName='Th2m.txt';
Th2m_array=load(fullfile(pathTh2m,fileName));
Th2m=assemblyTmatrix(Th2m_array);
% project
pc_m=myProjection_v3(pc_mm,Th2m);

%% delete ground
% find plane model and inliers index
maxDistance=50;%milimeters
[model,inlierIndices,outlierIndices]=pcfitplane(pc_m,maxDistance,[0 0 1]);
% delete inliers
    xyz=pc_m.Location;
    xyz(inlierIndices,:)=[];
    nonGroundPtCloud=pointCloud(xyz);


figure,
    pcshow(nonGroundPtCloud)
    hold on
    dibujarsistemaref(eye(4),'m',250,2,10,'w');
    grid on
    xlabel 'x'
    ylabel 'y'
    zlabel 'z'
    title (['pc wout ground sessionID/frameID ' num2str(sessionID) '/' num2str(frameID)])


%% estimate normals
normalV=pcnormals(nonGroundPtCloud);
Npoints=nonGroundPtCloud.Count;
figure,
    pcshow(nonGroundPtCloud)
    hold on
        x = nonGroundPtCloud.Location(1:10:end,1);
        y = nonGroundPtCloud.Location(1:10:end,2);
        z = nonGroundPtCloud.Location(1:10:end,3);
        u = normalV(1:10:end,1);
        v = normalV(1:10:end,2);
        w = normalV(1:10:end,3);
        quiver3(x,y,z,u,v,w);
    dibujarsistemaref(eye(4),'m',250,2,10,'w');
    grid on
    xlabel 'x'
    ylabel 'y'
    zlabel 'z'


%% perform clustering in 3d data

X=[nonGroundPtCloud.Location(:,1), nonGroundPtCloud.Location(:,2), ...
    nonGroundPtCloud.Location(:,3), normalV(:,1), normalV(:,2),...
    normalV(:,3)];

epsilon=100;
minpts=80;
idx = dbscan(X,epsilon,minpts);
Nclusters=max(idx);

figure,
myLegends={};
% myrows={};
for i=1:Nclusters
    
    rows=find(idx==i);
    myRows.(['cluster' num2str(i)])=rows;
    tempPC=pointCloud(nonGroundPtCloud.Location(rows,:));
    color=[ 0 0 i*10];
    tempPC=pcPaint(tempPC,color);
    pcshow(tempPC);
%     plot(X(rows,1),X(rows,2),'o');
    myLegends(i)={['cluster ' num2str(i)]};
    xmean=mean(nonGroundPtCloud.Location(rows,:));
    text(xmean(1),xmean(2),xmean(3),num2str(i));
     hold on
end
    xlabel 'x'
    ylabel 'y'
    grid
legend(myLegends)
return

%%compute normal of each cluster
model={};
for i=1:Nclusters
    rows=myRows.(['cluster' num2str(i)]);
    pc_i=pointCloud([nonGroundPtCloud.Location(rows,1),nonGroundPtCloud.Location(rows,2),...
        nonGroundPtCloud.Location(rows,3)]);
    myModel.(['cluster' num2str(i)])=pcfitplane(pc_i,50);
end
%% filter clusters with normal away a treshold
alpha=zeros(1,Nclusters);
for i=1:Nclusters
    P1=myModel.(['cluster' num2str(i)]).Normal;
    P2=[0 0 1];
    alpha(i)=computeAngleBtwnVectors(P1,P2);
end
criteria=abs(cos(alpha*pi/180));%angle in radians
% compute distance D
distanceD=zeros(Nclusters,1);
for i=1:Nclusters
    distanceD(i)=myModel.(['cluster' num2str(i)]).Parameters(4);
end



badDetections=0;
clusters=[];
for i=1:Nclusters
%     if criteria(i)<0.2
    if abs(distanceD(i))>2600
        badDetections=badDetections+1;
    else
        clusters=[clusters i];
    end
end
Nboxes=Nclusters-badDetections;
% display(['there are ' num2str(Nboxes) ' boxes in the frameID: Clusters ' num2str(clusters)])
title ([ num2str(Nboxes) ' boxes in the frameID ' num2str(frameID) ': Clusters ' num2str(clusters)])

