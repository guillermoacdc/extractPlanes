clc
close all
clear all
% path to extracted planes
processedScenesPath='G:\Mi unidad\semestre 9\HighOcclusionScenes_processed';
% processedScenesPath='G:\Mi unidad\semestre 9\MediumOcclusionScenes_processed';
% processedScenesPath='G:\Mi unidad\semestre 9\lowOcclusionScenes_processed';
% path to intiail value pose T_initialValue
T_initialValue=load("G:\Mi unidad\boxesDatabaseSample\corrida20\Th2m.txt");
% rootPath
rootPath="G:\Mi unidad\boxesDatabaseSample\";

flagGroundPlane=false;
scene=21;
boxIDref=19;
frames = getTargetFramesFromScene(scene);
idxBoxes=getIDxBoxes(rootPath,scene, boxIDref);

frame=frames(1);
% path to point cloud from HL2 sensors
% pathData=[rootPath + '\scene' + num2str(scene) + '\inputFrames\frame' + num2str(frame) + '.ply'];
pathPoints=[rootPath + 'corrida' + num2str(scene) + '\HL2\PointClouds\frame' + num2str(frame) + '.ply'];


gridStep=1;
%% Generate synthetic model points
spatialSampling=10;
numberOfSides=2;
% groundFlag=true;
% [pcmodel, planeDescriptor_gt, Nboxes] = generateSyntheticModelForScene(rootPath, ...
%     scene,spatialSampling,numberOfSides,flagGroundPlane, idxBoxes);
[pcmodel, planeDescriptor_gt, Nboxes] = generateSyntheticModelForScene(rootPath, ...
    scene,spatialSampling,numberOfSides,flagGroundPlane, idxBoxes, 0);
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
pcfileName=['pcFused_s' num2str(scene) '_b' num2str(boxIDref)];
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
return
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
fileName=([rootPath + [ 'corrida' num2str(scene) '\Th2m.txt'] ]);
fid=fopen(fileName,'w');
    fprintf(fid,'%1.4f ',Toutxt);
fclose(fid);
res

