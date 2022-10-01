% 

clc
close all
clear


scene=3;
frame=6;
keyBoxID=14;

% scene=5;%
% frame=5;
% keyBoxID=15;

% scene=6;
% frame=66;

% scene=21;
% frame=6;

% scene=51;
% frame=29;

rootPath="C:\lib\boxTrackinPCs\";


%% compute estimated planes in the scene
planesEstimated=detectPlanes(rootPath,scene,frame);
figure,
myPlotPlanes_v2(planesEstimated,planesEstimated.(['fr' num2str(frame)]).acceptedPlanes)
title (['boxes detected in scene/frame ' num2str(scene) '/' num2str(frame)])


% extract top planes (xzPlanes) from accepted planes
acceptedPlanes=planesEstimated.(['fr' num2str(frame)]).acceptedPlanes;
xzPlanes_e=extractTypes(planesEstimated, acceptedPlanes);
N_estimatedPlanes=size(xzPlanes_e,1);

%% create point clouds from estimated top planes
% Nboxes=size(planesEstimated.(['fr' num2str(frame)]).acceptedPlanes,1);
spatialSampling=10;
for i=1:N_estimatedPlanes
    % load height
    H=loadLengths(rootPath,scene);
    H=H(i,4);
    % load depth, width and height in scene
    L1=planesEstimated.(['fr' num2str(frame)]).values(xzPlanes_e(i,2)).L1*1000;
    L2=planesEstimated.(['fr' num2str(frame)]).values(xzPlanes_e(i,2)).L2*1000;
    pcBox{i}=createSingleBoxPC(L1,L2,H,spatialSampling);
end
% project point clouds with its own Tform
model=[];
for i=1:N_estimatedPlanes
    T=planesEstimated.(['fr' num2str(frame)]).values(xzPlanes_e(i,2)).tform;
    T(1:3,4)=T(1:3,4)*1000;
    pcBox_m{i}=myProjection_v3(pcBox{i},T);
    model=[model; pcBox_m{i}.Location];
end
pcmodel=pointCloud(model);

figure,
pcshow(pcmodel)
hold on
dibujarsistemaref(eye(4),'h',150,1,10,'w')
xlabel 'x'
ylabel 'y'
zlabel 'z'
grid on
title (['pc from detected planes scene/frame ' num2str(scene) '/' num2str(frame)])
