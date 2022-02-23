clc
close all
clear all

% this script filter detected planes by comparing its properties with
% respect to the expected values. 





%% load expected values
parameters=load('scene5Planes.txt');%IDplane, IdBox, L1(cm), L2(cm), normalType
L1max=max(parameters(:,3));
L2max=max(parameters(:,4));

L1min=min(parameters(:,3));
L2min=min(parameters(:,4));
e=5;
features=parameters(:,[3:5]);

%% define path to measured data (%point cloud,%model parameters)
frame=5;
in_planesFolderPath=['C:/lib/outputPlanes_t10/frame ('  num2str(frame)  ')/'];%extracted planes with efficientRANSAC
cd1=cd;
cd(in_planesFolderPath);
Files1=dir('*.ply');
cd(cd1)
numberPlanes=length(Files1);

%iterative processing
groundNormal=[0 1 0];% the height is in axis y
myTolerance=10;%degrees
k=1;
for i=2:numberPlanes%plane number 1 is ground plane
%     load plane parameters
    planeID=i;
    [modelParameters pc ]=loadPlaneParameters(in_planesFolderPath, frame, planeID);
%compute normal type
	normalType = computeNormalType( modelParameters(1), ...
            modelParameters(2), modelParameters(3), modelParameters(4), myTolerance);   
%filter non expected planes
    if (normalType==2)
        continue;
    end
    % orientation of normal correction in perpendicular planes
    if normalType==1
        if (modelParameters (4)<0 & pc.Count>200)
            modelParameters(1:4)=-modelParameters(1:4);%Invert orientation and distance's sign
        end
    end
%%    Filter planes with length (L1,L2) smaller or larger than the expected lengths in the scene; use a tolerance factor to include inaccuracy of the sensor.
    % compute plane segment parameters
    [out1 out2 ]=measurePlaneParameters(pc, modelParameters, groundNormal, myTolerance,0);
    
    
    if(out1*100>L1max+e | out1*100<L1min-e | out2*100>L2max+e | out2*100<L2min-e)
        continue
    end
    L1(k)=out1;
    L2(k)=out2;
    normalTypev(k)=normalType;
    k=k+1;
end

%% plot features

detectedFeatures=[L1' L2' normalTypev'];

figure,
plot3(features(:,1),features(:,2),100*features(:,3),'bo')
hold on
plot3(100*detectedFeatures(:,1),100*detectedFeatures(:,2),100*detectedFeatures(:,3),'ro')%convert from mt to cm; in the third dimension is not a conversion, just to separate the points
grid
xlabel 'L1'
ylabel 'L2'
zlabel 'Normal'
title (['Scene 5. Expected planes in blue ' num2str(size(features,1)) '; detected planes in red ' num2str(size(detectedFeatures,1)) ' - frame 5'])



