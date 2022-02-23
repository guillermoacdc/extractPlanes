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
nonExpectedIndex=[];
antiparallelNormalIndex=[];


for i=2:numberPlanes%plane number 1 is ground plane
%     load plane parameters
    planeID=i;
    [modelParameters pc ]=loadPlaneParameters(in_planesFolderPath, frame, planeID);
%     compute normal type
	normalType = computeNormalType( modelParameters(1), ...
            modelParameters(2), modelParameters(3), modelParameters(4), myTolerance);   
   %% filter non expected planes
    if (normalType==2)
        nonExpectedIndex=[nonExpectedIndex i];
        continue;
    end
   %% orientation of normal correction in perpendicular planes
    if normalType==1
        if (modelParameters (4)<0 & pc.Count>200)
            antiparallelNormalIndex=[ antiparallelNormalIndex i];
            modelParameters(1:4)=-modelParameters(1:4);%Invert orientation and distance's sign
        end
    end
    %% compute L1 L2
    [out1 out2 ]=measurePlaneParameters(pc, modelParameters, groundNormal, myTolerance,0);
    L1(k)=out1; %mt
    L2(k)=out2; %mt
    normalTypev(k)=normalType;
    k=k+1;
end

planesToProcessIndex=setdiff([2:numberPlanes],nonExpectedIndex);
%% filter by length
k=1;
filteredByLengthIndex=[];
for i=1:length(L1)
    if(L1(i)*100>L1max+e | L1(i)*100<L1min-e | L2(i)*100>L2max+e | L2(i)*100<L2min-e)
        filteredByLengthIndex=[filteredByLengthIndex planesToProcessIndex(i)];
        
    end
end


%Conclusiones
% 1. Se deben ajustar los planos perpendiculares que fueron cortados con el
% piso antes de aplicar el filtro de longitud, ejm plano 10
% 2. Se deben graficar los planos filtrados para determinar comportamientos
% a modificar o mejorar: filteredByLengthIndex, antiparallelNormalIndex,
% nonExpectedIdexes.

return
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



