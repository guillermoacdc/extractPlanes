clc
close all
clear all
flagGroundPlane=false;
T_scene5=load("G:\Mi unidad\boxesDatabaseSample\corrida3\Th2m_v4.txt");
% 
scene=1;
frames=[7 8];

% scene=3;
% frames=[49 63];

% scene=5;%
% frames=[4 5];

% scene=6;
% frames=[66 67];

% scene=10;%
% frames=[16 17];

% scene=12;%
% frames=[3 4];


% scene=21;
% frames=[35 36];

% scene=51;
% frames=[29 30]; 

% rootPath="C:\lib\boxTrackinPCs\";
rootPath="G:\Mi unidad\boxesDatabaseSample\";
frame=frames(1);
% path to point cloud from HL2 sensors
% pathData=[rootPath + '\scene' + num2str(scene) + '\inputFrames\frame' + num2str(frame) + '.ply'];
pathPoints=[rootPath + 'corrida' + num2str(scene) + '\HL2\PointClouds\frame' + num2str(frame) + '.ply'];


gridStep=1;
%% Generate synthetic model points
% load previous knowledge in form of plane objects
% frame_gt=0;
% planeDescriptor_gt = convertPK2PlaneObjects(rootPath,scene);
planeDescriptor_gt = convertPK2PlaneObjects_v2(rootPath,scene);
% create synthetic point clouds from loaded previous knowledge
Nboxes=size(planeDescriptor_gt.fr0.acceptedPlanes,1);
spatialSampling=10;
for i=1:Nboxes
    % compute angle btwn axis x (xm,xb)
    T=planeDescriptor_gt.fr0.values(i).tform;
    angle=computeAngleBtwnVectors([1 0 0]',T(1:3,1));
    if(T(2,1)<0)
        angle=-angle;
    end
    % load height
    H=loadLengths(rootPath,scene);
    H=H(i,4);
    % load depth and width for each box in scene
    L1=planeDescriptor_gt.fr0.values(i).L1;
    L2=planeDescriptor_gt.fr0.values(i).L2;
    % create the object
    pcBox{i}=createSingleBoxPC_v2(L1,L2,H,spatialSampling);
%     pcBox{i}=createSingleBoxPC(L1,L2,H,spatialSampling, angle);
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
% create a synthetic ground plane
xmin=-2000;
xmax=2000;
ymin=-1000;
ymax=3000;
step=10;
pcGround=createSyntheticGround(xmax, xmin, ymax, ymin, step);
% fuse the groudn with the model
pcmodel=pcmerge(pcmodel,pcGround,gridStep);
figure,
hold on
pcshow(pcmodel)
% hold on
% pcshow(pcGround)
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


%% Load data points
% fusion two consecutive frames in their accepted planes version

for i=1:length(frames)
    frame=frames(i);
    localPlanes=detectPlanes(rootPath,scene,frame);
    pc_singleFrame{i}=fusePointCloudsFromDetectedPlanes(localPlanes,gridStep,flagGroundPlane);
end
pc_h = pcmerge(pc_singleFrame{1},pc_singleFrame{2},gridStep);

% pc_h=fusionFrames(frames,scene,rootPath,maxDistance,refVector,opRange,gridStep);



% apply transformation of initial value
    offsetSynch=computeOffsetByScene_resync(scene);
% load Th_c
    Th_c=loadTh_c(rootPath,scene,frame);
% load Tm_c
%     Tm_c=loadTm_c(rootPath,scene,frame,offsetSynch);
%     T_scene5=load("G:\Mi unidad\boxesDatabaseSample\corrida5\Th2m_v2.txt");
%     T_scene5=load("G:\Mi unidad\boxesDatabaseSample\corrida10\Th2m_v2.txt");
    Tm_h=assemblyTmatrix(T_scene5);
% compute Tm_h
%     Tm_h=Tm_c*inv(Th_c);
% transform from h to m worlds
    pc_m=myProjection_v3(pc_h,Tm_h);
% % bypass initial value of pose
% pc_m=pc_h;

data=pc_m.Location;


pc_woutGround=pointCloud(data);

figure,
pcshow(pc_woutGround,"MarkerSize",10)
% pcshow(pc_h,"MarkerSize",10)
hold on
pcshow(pcmodel)
xlabel 'x'
ylabel 'y'
zlabel 'z'
grid on
title (['pc from HL2 scene/frame ' num2str(scene) '/' num2str(frame)])


return
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

% junction of gross transformation (Tm_h) and granular transformation
% (Ticp) into a single transformation and saving in disk
Tout=Ticp*Tm_h;
Toutxt=[Tout(1,[1:4]) Tout(2,[1:4]) Tout(3,[1:4]) res];
fileName=([rootPath + [ 'corrida' num2str(scene) '\Th2m.txt'] ]);
fid=fopen(fileName,'w');
    fprintf(fid,'%1.4f ',Toutxt);
fclose(fid);
res

