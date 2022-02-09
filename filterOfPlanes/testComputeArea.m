% 
clc
close all
clear

%% load the pointcloud
% Fixed script for plane 3, frame 2 - scene 5
planeID=7;
frame=5;
in_planesFolderPath=['C:/lib/outputPlanes_t10/frame ('  num2str(frame)  ')/'];%extracted planes with efficientRANSAC

% load plane parameters for the pointcloud (normal and geometric center)
[modelParameters pc ]=loadPlaneParameters(in_planesFolderPath, frame, planeID);
figure,
pcshow(pc)
xlabel 'x'
ylabel 'y'
zlabel 'z'
title (['single plane with parameters ' num2str(modelParameters)])


%% project inliers into the fitted model
pc_projected=projectInPlane(pc,modelParameters);
figure,
pcshow(pc_projected)
xlabel 'x'
ylabel 'y'
zlabel 'z'
title (['single plane with parameters ' num2str(modelParameters)])

%% compute convex hull on projected point cloud
    x=pc_projected.Location(:,1);
    y=pc_projected.Location(:,2);%represents height in pc
    z=pc_projected.Location(:,3);
% computing convex hull
    k = convhull(double(x),double(y),double(z));

% warning: next section just works for perpendicular to ground planes
% computing convex hull on 2D
    k2d = convhull(double(x),double(y));
    ind_corners=selectCorners(x(k2d),y(k2d));
    
    figure,    
    pcshow(pc_projected)
    hold on
    plot3(x(k),y(k),z(k),'bo','MarkerSize',6,'MarkerFaceColor','b')
%     hold on
%     plot3(x(ind_corners),y(ind_corners),z(ind_corners));
    xlabel 'x'
    ylabel 'y'
    zlabel 'z'
% title (['single plane with parameters ' num2str(modelParameters)]) 
% 
% 
% return
outCorners=setdiff(k2d, k2d(ind_corners));

figure,    
    plot(x(k2d),y(k2d),'bo','MarkerSize',6,'MarkerFaceColor','b')
    hold on
    plot(x(ind_corners),y(ind_corners),'ro','MarkerSize',6,'MarkerFaceColor','r')
    plot(x(outCorners),y(outCorners))
    title '2D version'