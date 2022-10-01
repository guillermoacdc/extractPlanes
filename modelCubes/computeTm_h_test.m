clc
close all
clear

% parameters
maxDistance=30;%mm
referenceVector=[0 0 1];
maxAngularDistance=15;
scene=5;%
frame=5;
rootPath="C:\lib\boxTrackinPCs\";
planesPath=rootPath+'scene'+num2str(scene)+'\detectedPlanes\frame'+num2str(frame)+'\';

% compute Tm_h
Tm_h = computeTm_h(rootPath,scene, 5)%length in mm. We have found in frame 5 the most accurate transformation!!

% load point cloud in h
pc_h=loadPointCloud(rootPath,scene, frame);%length in mm

% transform point cloud to m framework
% pc_m=myProjection(pc_h,Tm_h);
R=inv(Tm_h(1:3,1:3));
t=Tm_h(1:3,4);
pc_m=myProjection_v2(pc_h,R,t);

[model,inlierIndices,outlierIndices] = pcfitplane(pc_m,maxDistance,referenceVector,maxAngularDistance);
gcGround=[mean(pc_m.Location(inlierIndices,:))];
alpha=computeAngleBtwnVectors(model.Normal,[0 0 1]);%angle in degrees

figure,
pcshow(pc_m)
hold on
quiver3(gcGround(1),gcGround(2),...
    gcGround(3),model.Normal(1)*1000,model.Normal(2)*1000,model.Normal(3)*1000,'w')
title 'Projected point cloud'
xlabel 'x'
ylabel 'y'
zlabel 'z'
grid on

% rotate pc_m alpha deg around x axis
T=rotx(-double(alpha));
T1=eye(4);
T1(1:3,1:3)=T;
pc_m1=myProjection(pc_m,T1);
[model1,inlierIndices1,outlierIndices1] = pcfitplane(pc_m1,maxDistance,referenceVector,maxAngularDistance);
gcGround1=[mean(pc_m1.Location(inlierIndices,:))];
alpha1=computeAngleBtwnVectors(model1.Normal,[0 0 1]);%angle in degrees

% displace pcm1 D mm
T2=eye(4);
T2(3,4)=model1.Parameters(4);
pc_m2=myProjection(pc_m1,T2);

figure,
pcshow(pc_m2)
hold on
quiver3(gcGround1(1),gcGround1(2),...
    gcGround1(3),model1.Normal(1)*1000,model1.Normal(2)*1000,model1.Normal(3)*1000,'w')
title (['Projected and rotated point cloud. Angle btwn normals ' num2str(alpha1)])
xlabel 'x'
ylabel 'y'
zlabel 'z'
grid on
return



