clc
close all 
clear

%% crear datos 2D alineados con ejes x y
spatialSamplingRate=0.01;%10mm
L1=0.25;%25cm
L2=0.4;%40cm
% spatialSamplingRate=1;%1mm
% L1=10;%25cm
% L2=7;%40cm

% whole data
data=build2DallignedData(L1,L2, spatialSamplingRate);


%% crear versión ocluida

% tipo L
data2=build2DallignedData(0.85*L1,0.75*L2, spatialSamplingRate);
[datax index]=setdiff(data,data2,'rows');
dataOccluded=data(index,:);


% tipo L
data2=build2DallignedDataDiag(0.85*L1,0.75*L2, spatialSamplingRate);
[datax index]=setdiff(data,data2,'rows');
dataOccludedAugmented=data(index,:);

%% rotar datos completos y ocluidos
theta=-45*pi/180;
[data gc] = my2DRot(data,theta);
[dataOccluded gc_o] = my2DRot(dataOccluded,theta);
[dataOccludedAugmented gc_o2] = my2DRot(dataOccludedAugmented,theta);

%% aplicar pca y comparar graficamente
[eigenval,eigenvec]=pca_fun(data',2);
comp1=10*[eigenvec(1,1),eigenvec(2,1)];
comp2=10*[eigenvec(1,2),eigenvec(2,2)];

[eigenval_o,eigenvec_o]=pca_fun(dataOccluded',2);
comp1_o=10*[eigenvec_o(1,1),eigenvec_o(2,1)];
comp2_o=10*[eigenvec_o(1,2),eigenvec_o(2,2)];

[eigenval_o2,eigenvec_o2]=pca_fun(dataOccludedAugmented',2);
comp1_o2=10*[eigenvec_o2(1,1),eigenvec_o2(2,1)];
comp2_o2=10*[eigenvec_o2(1,2),eigenvec_o2(2,2)];



figure, 
plot(data(:,1),data(:,2),'*','color', [.5 .5 .5])%gray color in vector
hold on
title 'whole data'
quiver(gc(1),gc(2),comp1(1),comp1(2))
quiver(gc(1),gc(2),comp2(1),comp2(2))

figure, 
plot(dataOccluded(:,1),dataOccluded(:,2),'*','color', [.5 .5 .5])%gray color in vector
hold on
title 'occluded data 1'
quiver(gc_o(1),gc_o(2),comp1_o(1),comp1_o(2))
quiver(gc_o(1),gc_o(2),comp2_o(1),comp2_o(2))

figure, 
plot(dataOccludedAugmented(:,1),dataOccludedAugmented(:,2),'*','color', [.5 .5 .5])%gray color in vector
hold on
title 'augmented data'
quiver(gc_o2(1),gc_o2(2),comp1_o2(1),comp1_o2(2))
quiver(gc_o2(1),gc_o2(2),comp2_o2(1),comp2_o2(2))

return












% figure, 
% plot(dataOccluded2(:,1),dataOccluded2(:,2),'*','color', [.5 .5 .5])%gray color in vector
% hold on
% quiver(gc_o2(1),gc_o2(2),comp1_o2(1),comp1_o2(2))
% quiver(gc_o2(1),gc_o2(2),comp2_o2(1),comp2_o2(2))
% title 'occluded data 2'