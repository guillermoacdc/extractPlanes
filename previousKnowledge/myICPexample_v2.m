clc
close all
clear all

% scene=3;
% frames=[24 25];

scene=5;%
frames=[4 5];

% scene=6;
% frames=[66 67];

% scene=21;
% frames=[35 36];

% scene=51;
% frames=[29 30]; 

rootPath="C:\lib\boxTrackinPCs\";
frame=frames(1);
% path to point cloud from HL2 sensors
pathData=[rootPath + '\scene' + num2str(scene) + '\inputFrames\frame' + num2str(frame) + '.ply'];

%% Generate synthetic model points
% load previous knowledge in form of plane objects
frame_gt=0;
planeDescriptor_gt = convertPK2PlaneObjects(rootPath,scene);
% create synthetic point clouds from loaded previous knowledge
Nboxes=size(planeDescriptor_gt.fr0.acceptedPlanes,1);
spatialSampling=10;
for i=1:Nboxes
    % load height
    H=loadLengths(rootPath,scene);
    H=H(i,4);
    % load depth and width for each box in scene
    L1=planeDescriptor_gt.fr0.values(i).L1;
    L2=planeDescriptor_gt.fr0.values(i).L2;
    % create the object
    pcBox{i}=createSingleBoxPC(L1,L2,H,spatialSampling);
end
% project synthetic point clouds with its own Tform
model=[];
for i=1:Nboxes
    T=planeDescriptor_gt.fr0.values(i).tform;
    pcBox_m{i}=myProjection_v3(pcBox{i},T);
    model=[model; pcBox_m{i}.Location];%merge points into a single vector
end
% convert merged vector to a point cloud object
pcmodel=pointCloud(model);

%% Load data points
% filter parameters
maxDistance=30;%mm. To delete ground plane
refVector=[0 1 0];%. To delete ground plane
opRange=[0.5 3]*1000;%[min max] in mm. To filter points by distance to camera
gridStep=10;%grid step using for fusion

pc_h=fusionFrames(frames,scene,rootPath,maxDistance,refVector,opRange,gridStep);

% apply transformation of initial value
    offsetSynch=computeOffsetByScene_resync(scene);
% load Th_c
    Th_c=loadTh_c(rootPath,scene,frame);
% load Tm_c
    Tm_c=loadTm_c(rootPath,scene,frame,offsetSynch);
% compute Tm_h
    Tm_h=Tm_c*inv(Th_c);
% transform from h to m worlds
    pc_m=myProjection_v3(pc_h,Tm_h);
% % bypass initial value of pose
% pc_m=pc_h;

data=pc_m.Location;


pc_woutGround=pointCloud(data);


figure,
% pcshow(pc_woutGround,"MarkerSize",10)
hold on
pcshow(pcmodel)
for i=1:Nboxes
    boxID=planeDescriptor_gt.fr0.values(i).idBox;
    Tm=planeDescriptor_gt.fr0.values(i).tform;
    dibujarsistemaref(Tm,boxID,150,2,10,'w');
end
xlabel 'x'
ylabel 'y'
zlabel 'z'
grid on
title (['pc from scene/frame ' num2str(scene) '/' num2str(frame)])



%% Running the ICP-algorithm. Least squares criterion
data=double(data)';
model=model';
maxIter=100;
minIter=5;
critFun=1;
thres=1e-5;
[RotMat,TransVec,dataOut,res,iter]=icp(model,data,maxIter,minIter,critFun,thres);
Ticp=eye(4);
Ticp(1:3,1:3)=RotMat;
Ticp(1:3,4)=TransVec;




pc_aligned=pointCloud(dataOut');
pointscolor=uint8(zeros(pc_aligned.Count,3));
% cyan
pointscolor(:,1)=0;
pointscolor(:,2)=255;
pointscolor(:,3)=255;
pc_aligned.Color=pointscolor;
% 

figure,
pcshow(pcmodel)
hold on
pcshow(pc_aligned)
xlabel 'x'
ylabel 'y'
zlabel 'z'
grid on
title(['Transformed data (gray) and model (color). Residual/iterations= ' num2str(res,'%.2f') '/' num2str(iter)])


