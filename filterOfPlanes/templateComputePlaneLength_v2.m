clc
close all
clear 
%% read the pc
% planeID=7; %for perpendicular plane that is attracted to x axis, 6
planeID=14; %for perpendicular plane that is attracted to z axis
frame=5;
in_planesFolderPath=['C:/lib/outputPlanes_t10/frame ('  num2str(frame)  ')/'];%extracted planes with efficientRANSAC
% pc = pcread('onePlane2.ply');%plane in axis x,y

[modelParameters pc ]=loadPlaneParameters(in_planesFolderPath, frame, planeID);

figure,
pcshow(pc,'MarkerSize',20)
xlabel 'x'
ylabel 'y'
zlabel 'z'



%% computing 2D convex hull
x=pc.Location(:,1);
y=pc.Location(:,2);
z=pc.Location(:,3);

    k = convhull(double(x),double(y));
    ind_corners=selectCorners(x(k),y(k));

    figure,
    clf
    hold on

    plot(x,y,'k*')
    plot(x(k),y(k),'r-','LineWidth',2)
    plot(x(k),y(k),'bo','MarkerSize',6,'MarkerFaceColor','b')
    plot(x(k(ind_corners)),y(k(ind_corners)),'yo','MarkerSize',6,'MarkerFaceColor','y')
    title ('2D convex hull')
    
%% computing 3D convex hull
% project inliers into the fitted model
pc_projected=projectInPlane(pc,modelParameters);
figure,
pcshow(pc_projected)
xlabel 'x'
ylabel 'y'
zlabel 'z'
title (['projected plane '])

    x=pc_projected.Location(:,1);
    y=pc_projected.Location(:,2);%represents height in pc
    z=pc_projected.Location(:,3);
% computing convex hull
    k = convhull(double(x),double(y),double(z));
 figure,    
    pcshow(pc_projected)
    hold on
%     plot3(x(k),y(k),z(k),'r-','LineWidth',2)
    plot3(x(k),y(k),z(k),'bo')
    xlabel 'x'
    ylabel 'y'
    zlabel 'z'
    title (['3D convex hull'])
    
%% compute tform to allign plane to planes xy or xz
% for perpendicular planes

xdeviation=std(x);
zdeviation=std(z);
if(xdeviation>zdeviation)%compute angle with normal [1 0 0]
    alpha=computeAngleBtwnVectors([1 0 0], modelParameters(1:3));
else%compute deviation with normal [0 0 1]
    alpha=computeAngleBtwnVectors([0 0 -1], modelParameters(1:3));
end
t=eye(4);
t(1:3,1:3)=roty(-alpha);%angle in degrees
% t(1:3,4)=modelParameters(5:7)';
tform = affine3d(t);

D = repmat(-modelParameters(5:7),size(pc.Location,1),1);
pc_rotated1 = pctransform(pc_projected,D);%ptcloud centered in origin
pc_rotated2 = pctransform(pc_rotated1,tform);%ptcloud alligned to axis
figure,
pcshow(pc_rotated1,'MarkerSize',20)
hold on
pcshow(pc_rotated2,'MarkerSize',20)
xlabel 'x'
ylabel 'y'
zlabel 'z'
title ('rotation to allign to origin')
%compute convexhull in 2D
if(xdeviation>zdeviation)%ignore x values
    x1=pc_rotated2.Location(:,2);
    y1=pc_rotated2.Location(:,3);    
else%ignore z values
    x1=pc_rotated2.Location(:,1);
    y1=pc_rotated2.Location(:,2);    
end

    k1 = convhull(double(x1),double(y1));
    ind_corners=selectCorners(x1(k1),y1(k1));

    figure,
    clf
    hold on

    plot(x1,y1,'k*')
    plot(x1(k1),y1(k1),'r-','LineWidth',2)
    plot(x1(k1),y1(k1),'bo','MarkerSize',6,'MarkerFaceColor','b')
%     plot(x(k(ind_corners)),y(k(ind_corners)),'yo','MarkerSize',6,'MarkerFaceColor','y')
    title ('2D convex hull')
    
