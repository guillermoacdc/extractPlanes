clc
close all
clear 

% _v3: consuming data form 6dViCuT path
sessionID=10;
frameID=12;
dataSetPath=computeMainPaths(sessionID);
% 1. Plane filtering parameters
th_angle=15*pi/180;%radians
th_size=150;%number of points
th_lenght=10*10;%mm 10 cm - Update with tolerance_length; is in a high value (30) to pass most of the planes
th_occlusion=1.4;%
D_Tolerance=0.1*1000;%mm ... 0.1 m
planeFilteringParameters=[th_lenght, th_size, th_angle, th_occlusion, D_Tolerance];

% 2 path parameters
processedScenesPath='D:\6DViCuT_p1\processedPCs\lowOcclusionScenes_processed';
rootPath=computeMainPaths(sessionID);

flagGroundPlane=false;
outputFileName='Th2m.txt';
% pathInitValue=fullfile(rootPath,[ 'session' num2str(sessionID)],'analyzed',outputFileName);
pathInitValue=fullfile(rootPath,'updatedGTPoses',[ 'session' num2str(sessionID)],'analyzed',outputFileName);
T_initialValue=load(pathInitValue);

% [reposFlag,reposFrame] = isRepositioned(rootPath,sessionID,2);
reposFlag=false;

% frames = getTargetFramesFromScene(sessionID);
idxBoxes=getIDxBoxes(rootPath,sessionID);

% frameID=frames(2);
fileName=['frameID'  num2str(frameID)  '.ply'];
pathPoints=fullfile(rootPath, ['session' num2str(sessionID)], 'filtered', 'HL2', 'PointClouds', fileName );


gridStep=1;
%% Generate synthetic model points
spatialSampling=10;
% numberOfSides=3;
NpointsDiagTopSide=60;
planeType=0;
boxIDref=getPPS(rootPath,sessionID,frameID);
sidesVector=[1 2 3 4 5];
Nsides=length(sidesVector);
Nboxes=length(boxIDref);
planeDescriptor_gt=[];
for i=1:Nboxes
    boxID=boxIDref(i);
    % load descriptors of planes that compose boxID
    planeDescriptor_temp = convertPK2PlaneObjects_v5(boxID,sessionID, ...
    sidesVector, frameID);
    planeDescriptor_gt=[planeDescriptor_gt, planeDescriptor_temp];
    % create synthetic PC
    pcmodel_temp=createSyntheticPC_v2(planeDescriptor_temp,...
        NpointsDiagTopSide,boxID, gridStep, dataSetPath);
    if i>1%merge pcs
        pcmodel=pcmerge(pcmodel,pcmodel_temp,gridStep);
    else
        pcmodel=pcmodel_temp;
    end
end

% [pcmodel, planeDescriptor_gt] = generateSyntheticPC(boxIDref,sessionID, ...
%     numberOfSides, frameID, NpointsDiagTopSide, planeType, rootPath);
Nboxes=size(planeDescriptor_gt,2);


figure,
hold on
pcshow(pcmodel)
for i=1:Nsides:Nboxes
    boxID=planeDescriptor_gt(i).idBox;
    Tm=planeDescriptor_gt(i).tform;
    dibujarsistemaref(Tm,boxID,150,2,10,'w');
end
xlabel 'x'
ylabel 'y'
zlabel 'z'
grid on
title (['synthetic pc from sessionID ' num2str(sessionID)])

%% Load data points

    disp(['session ' num2str(sessionID) ', frameID ' num2str(frameID)])
    localPlanes=loadExtractedPlanes(rootPath,sessionID,frameID,...
        processedScenesPath, planeFilteringParameters, 1, 0);%
    pc_h=fusePointCloudsFromDetectedPlanes(localPlanes,gridStep,flagGroundPlane);


    Tm_h=assemblyTmatrix(T_initialValue);
% transform from h to m worlds
    pc_m=myProjection_v3(pc_h,Tm_h);
data=pc_m.Location;
pc_woutGround=pointCloud(data);

figure,
pcshow(pc_woutGround,"MarkerSize",10)
hold on
% add box ID to the figure
for i=1:Nsides:Nboxes
    boxID=planeDescriptor_gt(i).idBox;
    Tm=planeDescriptor_gt(i).tform;
    dibujarsistemaref(Tm,boxID,150,2,10,'w');
end
hold on
pcshow(pcmodel)
xlabel 'x'
ylabel 'y'
zlabel 'z'
grid on
title (['pc from HL2 sessionID/frameID ' num2str(sessionID) '/' num2str(frameID)])


% removing warnings
w = warning('query','last');
id=w.identifier;
warning('off',id)