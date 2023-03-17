
clc
close all
clear all
scene=3;
frame=24;

% scene=5;%
% frame=5;

% scene=6;
% frame=66;

% scene=51;
% frame=6;

% scene=51;
% frame=29;

% rootPath='C:\lib\boxTrackinPCs\';
rootPath="G:\Mi unidad\boxesDatabaseSample\";
% pathPoints=[rootPath '\scene' num2str(scene) '\inputFrames\frame' num2str(frame) '.ply'];
pathPoints=[rootPath + 'corrida' + num2str(scene) + '\HL2\PointClouds\frame' + num2str(frame) + '.ply'];

%% Generate model points
% load previous knowledge in form of plane objects
frame_gt=0;
planeDescriptor_gt = convertPK2PlaneObjects(rootPath,scene);
% create point clouds from loaded previous knowledge
Nboxes=size(planeDescriptor_gt.fr0.acceptedPlanes,1);
spatialSampling=5;
for i=1:Nboxes
    % compute sign angle between (x-world,x-box)
    T=planeDescriptor_gt.fr0.values(i).tform;
    angle=computeAngleBtwnVectors([1 0 0],T(1:3,1));
    if (T(2,1)<0)
        angle=-angle;
    end
    % load height
    H=loadLengths(rootPath,scene);
    H=H(i,4);
    % load depth, width and height in scene
    L1=planeDescriptor_gt.fr0.values(i).L1;
    L2=planeDescriptor_gt.fr0.values(i).L2;
    pcBox{i}=createSingleBoxPC(L1,L2,H,spatialSampling,angle);
end
% project point clouds with its own Tform
model=[];
for i=1:Nboxes
    T=planeDescriptor_gt.fr0.values(i).tform;
    pcBox_m{i}=myProjection_v3(pcBox{i},T);
    model=[model; pcBox_m{i}.Location];
end


%% Generate data points
pc = pcread(pathPoints);%in [mt]; indices begin at 0
% convert to mm
    xyz=pc.Location*1000;
    pc_mm=pointCloud(xyz);

% delete ground plane
maxDistance=10;%mm
refVector=[0 1 0];
[model,inlierIndices,outlierIndices] = pcfitplane(pc_mm,maxDistance,refVector);

data=pc_mm.Location(outlierIndices,:);
pc_woutGround=pointCloud(data);

figure,
pcshow(pc_woutGround)
xlabel 'x'
ylabel 'y'
zlabel 'z'
grid on
title (['pc scanned from scene/frame ' num2str(scene) '/' num2str(frame)])


return
%% Running the ICP-algorithm. Least squares criterion
[RotMat,TransVec,dataOut]=icp(model,data);

% Reference:
%
% Bergström, P. and Edlund, O. 2014, 'Robust registration of point sets using iteratively reweighted least squares'
% Computational Optimization and Applications, vol 58, no. 3, pp. 543-561, 10.1007/s10589-014-9643-2


% A plot. Model points and data points in transformed positions

figure(2)
plot3(model(1,:),model(2,:),model(3,:),'r.',dataOut(1,:),dataOut(2,:),dataOut(3,:),'g.'), hold on, axis equal
plot3([1 1 0],[0 1 1],[0 0 0],'r-',[1 1],[1 1],[0 1],'r-','LineWidth',2)
title('Transformed data points (green) and model points (red)')

