% This scripts loads and plot an input frame 

clc
close all
clear 

% focalLength    = [800 800]/2; 
% principalPoint = [320 240];
% imageSize      = [principalPoint(2)*2 principalPoint(1)*2];
%              FocalLength: [4.5539e+03 4.6161e+03]
%           PrincipalPoint: [1.4164e+03 1.1082e+03]
%                ImageSize: [1880 2816]
focalLength    = [4553 4616]; 
principalPoint = [1416 1108];
imageSize      = [1880 2816];
sessionID=10;%
frame=205;%205
%% load point cloud
[pc_mm, Thm]=loadSLAMoutput_v2(sessionID,frame); 
Thf=eye(4);
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
    title (['pc wout ground sessionID/frame ' num2str(sessionID) '/' num2str(frame)])
%% project camera to ceil
Tm2c=eye(4);
Tm2c(1:3,1:3)=[0 1 0; 1 0 0; 0 0 -1];
Tm2c(1:3,4)=[0 0 1000];
% project
pc_c=myProjection_v3(nonGroundPtCloud,Tm2c);
figure,
    pcshow(pc_c)
    hold on
    dibujarsistemaref(eye(4),'c',250,2,10,'w');
    grid on
    xlabel 'x'
    ylabel 'y'
    zlabel 'z'
    title (['pc wout ground sessionID/frame ' num2str(sessionID) '/' num2str(frame)])
        
%% extract 2D data
% X=[pc_c.Location(:,1),pc_c.Location(:,2)];
X=[nonGroundPtCloud.Location(:,1),nonGroundPtCloud.Location(:,2)];

figure,
    plot(X(:,1),X(:,2),"ko");
    xlabel 'x'
    ylabel 'y'
    grid
%%perform clustering in 2D data
epsilon=100;
minpts=80;
idx = dbscan(X,epsilon,minpts);
Nclusters=max(idx);
figure,
myLegends={};
for i=1:Nclusters
    rows=find(idx==i);
    plot(X(rows,1),X(rows,2),'o');
    myLegends(i)={['cluster ' num2str(i)]};
    hold on
end
    xlabel 'x'
    ylabel 'y'
    grid
legend(myLegends)
