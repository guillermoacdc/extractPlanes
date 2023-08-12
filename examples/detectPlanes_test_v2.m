clc
close all
clear all

% scene=51;%
% frame=6;

scene=3;%
frame=19;
% 1. Plane filtering parameters
th_angle=15*pi/180;%radians
th_size=150;%number of points
th_lenght=10*10;%mm 10 cm - Update with tolerance_length; is in a high value (30) to pass most of the planes
th_occlusion=1.4;%
D_Tolerance=0.1*1000;%mm ... 0.1 m
planeFilteringParameters=[th_lenght, th_size, th_angle, th_occlusion, D_Tolerance];

% 2. paths parameteres
[rootPath,evalPath,processedScenesPath] =computeMainPaths(scene);
% processedScenesPath='G:\Mi unidad\semestre 9\lowOcclusionScenes_processed';

% localPlanes=detectPlanes(rootPath,scene,frame,processedScenesPath);
localPlanes=loadExtractedPlanes(rootPath,scene,frame,...
        processedScenesPath, planeFilteringParameters);%returns a struct with a property frx - h world
allPlanes=localPlanes.(['fr' num2str(frame)]).acceptedPlanes;
[xzPlanes, xyPlanes, zyPlanes] = extractTypes(localPlanes, allPlanes);
idPlane=3;
% load camera pose
Tc=localPlanes.(['fr' num2str(frame)]).cameraPose;
% Tc(1:3,4)=localPlanes.(['fr' num2str(frame)]).values(idPlane).tform(1:3,4);
figure,
myPlotPlanes_v2(localPlanes,allPlanes, false)
% myPlotPlanes_v2(localPlanes,computeAllPlanesIds(localPlanes), false)
% axis square
hold on
dibujarsistemaref(Tc,'h',0.5,2,10,'w')
title (['boxes detected in scene/frame ' num2str(scene) '/' num2str(frame)])
return

acceptedPlanes=[frame 7; frame 3; frame 11];
flagGroundPlane=false;
gridStep=1;
pc_h = fusePointCloudsFromDetectedPlanes_v2(localPlanes,gridStep, flagGroundPlane, acceptedPlanes);
figure,
pcshow(pc_h)
xlabel 'x'
ylabel 'y'
zlabel 'z'
title ('fused version in a single point cloud')



% filename=['pcFused_s' num2str(scene) '_b' num2str()]
% save(filename,pc_h)

return
[fList,pList] = matlab.codetools.requiredFilesAndProducts('detectPlanes_test.m');

N=size(fList,1);
destPath='C:\Users\Acer\Documents\planeExtractor\extractPlanes\evaluatePoseError';
for i=1:N 
    sourcePath=fList{i};
    command=['copy ' sourcePath ' ' destPath];
    [status,cmdout]=system(command)
end



