clc
close all
clear all

% rootPath="C:\lib\boxTrackinPCs\";
rootPath="G:\Mi unidad\boxesDatabaseSample\";
scene=3;
% boxID=13;
planeType=0;
adjustPoseFlag=false;
[topPlaneDescriptor, pps]= convertPK2PlaneObjects_v2(rootPath,scene,planeType, adjustPoseFlag);


%% create point clouds from loaded previous knowledge
Nboxes=size(topPlaneDescriptor.fr0.acceptedPlanes,1);
spatialSampling=10;
for i=1:Nboxes
    % compute sign angle between (x-world,x-box)
    T=topPlaneDescriptor.fr0.values(i).tform;
    angle=computeAngleBtwnVectors([1 0 0],T(1:3,1));
    if (T(2,1)<0)
        angle=-angle;
    end
    % load height
    H=loadLengths_v2(rootPath,scene,pps);
    H=H(i,2);
    % load depth, width and height in scene
    L1=topPlaneDescriptor.fr0.values(i).L1;
    L2=topPlaneDescriptor.fr0.values(i).L2;
    pcBox{i}=createSingleBoxPC(L1,L2,H,spatialSampling,angle);
end
%% project point clouds with its own Tform
for i=1:Nboxes
    T=topPlaneDescriptor.fr0.values(i).tform;
    pcBox_m{i}=myProjection_v3(pcBox{i},T);
end

%% compute tform for side planes
xzPlaneDescriptor = convertPK2PlaneObjects_v2(rootPath,scene,1,adjustPoseFlag);
yzPlaneDescriptor = convertPK2PlaneObjects_v2(rootPath,scene,2,adjustPoseFlag);
% top planes
figure,
for i=1:Nboxes
    boxID=topPlaneDescriptor.fr0.values(i).idBox;
    T=topPlaneDescriptor.fr0.values(i).tform;    
    pcshow(pcBox_m{i});
    hold on
    dibujarsistemaref(T,boxID,150,1,15,'w');    
end
dibujarsistemaref(eye(4),'m',100,1,10,'w');
xlabel 'x'
ylabel 'y'
zlabel 'z'
grid on
title (['top frames at scene' num2str(scene)])
display ('Physical Packing Sequence:')
pps'

return
% xz planes
figure,
for i=1:Nboxes
    boxID=topPlaneDescriptor.fr0.values(i).idBox;
    T=xzPlaneDescriptor.fr0.values(i).tform;    
    pcshow(pcBox_m{i});
    hold on
    dibujarsistemaref(T,boxID,150,1,15,'w');    
end
dibujarsistemaref(eye(4),'m',100,1,10,'w');
xlabel 'x'
ylabel 'y'
zlabel 'z'
grid on
title (['xz frames at scene' num2str(scene)])

% yzplanes
figure,
for i=1:Nboxes
    boxID=topPlaneDescriptor.fr0.values(i).idBox;
    T=yzPlaneDescriptor.fr0.values(i).tform;    
    pcshow(pcBox_m{i});
    hold on
    dibujarsistemaref(T,boxID,150,1,15,'w');    
end
dibujarsistemaref(eye(4),'m',100,1,10,'w');
xlabel 'x'
ylabel 'y'
zlabel 'z'
grid on
title (['yz frames at scene' num2str(scene)])




return
% compute distance btwn two planes poses to assess the accuracy in
% reconstruction
% box=13. index=1
gcTopPlane=topPlaneDescriptor.fr0.values(1).tform(1:3,4);
gcs1Plane=xzPlaneDescriptor.fr0.values(1).tform(1:3,4);
% compute distance between ref systems (176,77mm)
distance=norm(gcTopPlane-gcs1Plane);
% compute distance based on box lengths (195,25mm)
dexpected=sqrt(150^2+125^2);
% Conclusion. The reference systems are nearer than expected (18.48 mm nearer). So the point
% cloud is ok. Seek the error in the generation and transformation of
% references systems
dexpected-distance;
