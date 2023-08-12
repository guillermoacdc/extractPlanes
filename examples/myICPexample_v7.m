clc
close all
clear all

scene=3;
boxIDref=19;
% path to intiail value pose T_initialValue

% T_initialValue=load("G:\Mi unidad\boxesDatabaseSample\corrida20\Th2m.txt");

T_initialValue=load("D:\6DViCuT_p1\updatedGTPoses\session3\analyzed\Th2m.txt");
% rootPath
% rootPath="G:\Mi unidad\boxesDatabaseSample\";
[rootPath,evalPath,processedScenesPath] =computeMainPaths(scene);
% fileNameT='Th2m_vc.txt';
% T_initialValue=fullfile(rootPath,'updatedGTPoses',...
%     ['session' num2str(scene)],'analyzed', fileNameT);
flagGroundPlane=false;

frames = getTargetFramesFromScene(scene);
idxBoxes=getIDxBoxes(rootPath,scene, boxIDref);

frame=frames(2);
% path to point cloud from HL2 sensors
fileName=['frame'  num2str(frame)  '.ply'];
pathPoints=fullfile(rootPath, ['session' num2str(scene)],...
    'filtered', 'HL2', 'PointClouds', fileName );
gridStep=1;
%% Generate synthetic model points
spatialSampling=10;
numberOfSides=3;
NpointsDiagTopSide=90;
planeType=0;
% groundFlag=true;
% [pcmodel, planeDescriptor_gt, Nboxes] = generateSyntheticModelForScene(rootPath, ...
%     scene,spatialSampling,numberOfSides,flagGroundPlane, idxBoxes);
% [pcmodel, planeDescriptor_gt, Nboxes] = generateSyntheticModelForScene(rootPath, ...
%     scene,numberOfSides,flagGroundPlane, idxBoxes, frame, 30, 0);
[pcmodel, planeDescriptor_gt] = generateSyntheticPC(boxIDref,scene, ...
    numberOfSides, frame, NpointsDiagTopSide, planeType, rootPath);
Nboxes=size(planeDescriptor_gt.fr0.values,2);

% generateSyntheticModelForScene(rootPath, ...
%     scene,numberOfSides,groundFlag,idxBoxes,frameHL2, NpointsDiagTopSide, planeType)

figure,
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
title (['synthetic pc from scene ' num2str(scene)])
% return
%% Load data points
% fusion two consecutive frames in their accepted planes version
% pc_h = pcmerge(pc_singleFrame{1},pc_singleFrame{2},gridStep);
% load pc_h from disk
% pcfileName=['pcFused_s' num2str(scene) '_b' num2str(boxIDref)];
pcfileName=['pcFused_s' num2str(scene) '_b' num2str(boxIDref) '_3s'];
load (pcfileName)
Tm_h=assemblyTmatrix(T_initialValue);
pc_m=myProjection_v3(pc_h,Tm_h);
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

%% Running the ICP-algorithm. Least squares criterion
data=double(data)';
model=pcmodel.Location';
maxIter=100;
minIter=5;
critFun=2;
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
return
% junction of gross transformation (Tm_h) and granular transformation
% (Ticp) into a single transformation and saving in disk
Tout=Ticp*Tm_h;
Toutxt=[Tout(1,[1:4]) Tout(2,[1:4]) Tout(3,[1:4]) res];
% fileName=([rootPath + [ 'session' num2str(scene) '\Th2m.txt'] ]);
outputFileName='Th2m.txt';
filePath=fullfile(rootPath,'updatedGTPoses',[ 'session' num2str(scene)],'analyzed',outputFileName)
fid=fopen(filePath,'w');
    fprintf(fid,'%1.4f ',Toutxt);
fclose(fid);
res

