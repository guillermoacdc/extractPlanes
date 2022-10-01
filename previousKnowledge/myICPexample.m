
clc
close all
clear all
% scene=3;
% frame=24;

% scene=5;%
% frame=5;

scene=6;
frame=66;

% scene=51;
% frame=6;

% scene=51;
% frame=29;

rootPath="C:\lib\boxTrackinPCs\";
pathData=[rootPath + '\scene' + num2str(scene) + '\inputFrames\frame' + num2str(frame) + '.ply'];
%% Generate model points
% load previous knowledge in form of plane objects
frame_gt=0;
planeDescriptor_gt = convertPK2PlaneObjects(rootPath,scene);
% create point clouds from loaded previous knowledge
Nboxes=size(planeDescriptor_gt.fr0.acceptedPlanes,1);
spatialSampling=10;
for i=1:Nboxes
    % load height
    H=loadLengths(rootPath,scene);
    H=H(i,4);
    % load depth, width and height in scene
    L1=planeDescriptor_gt.fr0.values(i).L1;
    L2=planeDescriptor_gt.fr0.values(i).L2;
    pcBox{i}=createSingleBoxPC(L1,L2,H,spatialSampling);
end
% project point clouds with its own Tform
model=[];
for i=1:Nboxes
    T=planeDescriptor_gt.fr0.values(i).tform;
    pcBox_m{i}=myProjection_v3(pcBox{i},T);
    model=[model; pcBox_m{i}.Location];
end
pcmodel=pointCloud(model);

%% Load data points
pc = pcread(pathData);%in [mt]; indices begin at 0
% convert to mm
    xyz=pc.Location*1000;
    pc_mm=pointCloud(xyz);

% delete ground plane
maxDistance=15;%mm
refVector=[0 1 0];
[~,inlierIndices,outlierIndices] = pcfitplane(pc_mm,maxDistance,refVector);

data1=pc_mm.Location(outlierIndices,:);
pc_h=pointCloud(data1);
% apply first transformation
    offsetSynch=computeOffsetByScene_resync(scene);
% load Th_c
    Th_c=loadTh_c(rootPath,scene,frame);
% load Tm_c
    Tm_c=loadTm_c(rootPath,scene,frame,offsetSynch);
% compute Tm_h
    Tm_h=Tm_c*inv(Th_c);
% transform from h to m worlds
    pc_m=myProjection_v3(pc_h,Tm_h);

data=pc_m.Location;


pc_woutGround=pointCloud(data);

% figure,
% pcshow(pc_woutGround)
% xlabel 'x'
% ylabel 'y'
% zlabel 'z'
% grid on
% title (['pc from scene/frame ' num2str(scene) '/' num2str(frame)])

figure,
pcshow(pc_woutGround,"MarkerSize",10)
hold on
pcshow(pcmodel)
xlabel 'x'
ylabel 'y'
zlabel 'z'
grid on
title (['pc from scene/frame ' num2str(scene) '/' num2str(frame)])


return
%% Running the ICP-algorithm. Least squares criterion
data=double(data)';
model=model';
maxIter=100;
minIter=5;
critFun=3;
thres=1e-4;
[RotMat,TransVec,dataOut]=icp(model,data,maxIter,minIter,critFun,thres);

% Reference:
%
% Bergström, P. and Edlund, O. 2014, 'Robust registration of point sets using iteratively reweighted least squares'
% Computational Optimization and Applications, vol 58, no. 3, pp. 543-561, 10.1007/s10589-014-9643-2


% A plot. Model points and data points in transformed positions

figure,
plot3(model(1,:),model(2,:),model(3,:),'r.',dataOut(1,:),dataOut(2,:),dataOut(3,:),'g.'), hold on, axis equal
plot3([1 1 0],[0 1 1],[0 0 0],'r-',[1 1],[1 1],[0 1],'r-','LineWidth',2)
title('Transformed data points (green) and model points (red)')
xlabel x
ylabel y
zlabel z
grid on 


