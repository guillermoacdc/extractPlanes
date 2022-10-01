function [tform_gt L1_gt L2_gt]=loadGTData_v2(rootPath, scene, keybox)
%LOADGTDATA Load the pose of each box in the scene. This pose was estimated
%from the mocap markers that were tracking in the initial state of the
%packing operation
%   Detailed explanation goes here

% Assumption 1. The Reference System attached to each upper plane of the 
% box uses the minor edge of the plane as the x-axis, the major edge as 
% the y-axis and the antigravity vector as the z-axis. Height is measured 
% along the positive z axis

% tform is available in the file rootPath/scenex/Mocap_initialPoseBoxes.csv 
fileName=rootPath  + 'scene' + num2str(scene) + '\initialPoseBoxes.csv';
initialPosesT= readtable(fileName);
initialPosesA = table2array(initialPosesT);
row=find(initialPosesA(:,1)==keybox);
tform_gt=assemblyTmatrix(initialPosesA(row,3:14));%length is loaded in mm

% Length information is in previousKnowledgeFile.txt
% fileName=rootPath  + 'scene' + num2str(scene) +'\previousKnowledgeFile.txt';
% lengthInfo=load(fileName);
lengthInfo = loadLengths(rootPath,scene);%loaded in mm
row=find(lengthInfo(:,1)==keybox);

L1_gt=lengthInfo(row,2);
L2_gt=lengthInfo(row,3);
% L3_gt=lengthInfo(row,3);%height
% 
if L1_gt>L2_gt
    aux=L1_gt;
    L1_gt=L2_gt;
    L2_gt=aux;
end
% rotate the frame to satisfy assumption 1
% Tnorm=eye(4);
% Tnorm(1:3,1:3)=rotz(-90);
% tform_gt=tform_gt*Tnorm;

% plot the box
n=tform_gt(1:3,4);
modelParameters=[0 0 1 n(3) n(1) n(2) n(3)];
%     create the plane object
planeDescriptor=plane(0, 0, 0, modelParameters,...
        'noPath', 0);%scene,frame,pID,pnormal,Nmbinliers
planeDescriptor.tform=tform_gt;
planeDescriptor.type=0;
planeDescriptor.planeTilt=1;%xz inclination
planeDescriptor.L1=L1_gt;%mm
planeDescriptor.L2=L2_gt;%mm
planeDescriptor.L2toY=1;%must be loaded as L2 to z. Define a way to measure


figure,
    T0=eye(4,4);
    dibujarsistemaref(tform_gt,keybox,300,1,10,'black')%(T,ind,scale,width,fs,fc)
    hold on
    dibujarsistemaref(T0,'m',1000,1,10,'black')%(T,ind,scale,width,fs,fc)
    myPlotPlaneContourPerpend(planeDescriptor)
    grid on 
    xlabel x
    ylabel y
    zlabel z
    title (['frames q_b and q_m for box id: ' num2str(keybox)])


end

