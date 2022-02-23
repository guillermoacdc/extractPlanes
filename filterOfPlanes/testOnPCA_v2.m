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

data=build2DallignedData(L1,L2, spatialSamplingRate);


%% crear versión ocluida
% rebanada
% for i=1:length(data)/2
%     dataOccluded(i,:)=data(i,:);
% end
% dataOccluded=[dataOccluded; data(end,:)];

% tipo L
data2=build2DallignedData(0.85*L1,0.75*L2, spatialSamplingRate);
[datax index]=setdiff(data,data2,'rows');
dataOccluded=data(index,:);
% compute convex hull
kIndex = convhull(double(dataOccluded(:,1)),double(dataOccluded(:,2)));


% diagonal ppal
data2=build2DallignedDataDiag(L1,L2, spatialSamplingRate);
[datax index]=setdiff(data,data2,'rows');
dataOccluded2=data(index,:);

%% rotar datos completos y ocluidos
theta=-45*pi/180;
[data gc] = my2DRot(data,theta);
[dataOccluded gc_o] = my2DRot(dataOccluded,theta);
[dataOccluded2 gc_o2] = my2DRot(dataOccluded2,theta);


%% aplicar pca y comparar graficamente
[eigenval,eigenvec]=pca_fun(data',2);
comp1=10*[eigenvec(1,1),eigenvec(2,1)];
comp2=10*[eigenvec(1,2),eigenvec(2,2)];

[eigenval_o,eigenvec_o]=pca_fun(dataOccluded',2);
comp1_o=10*[eigenvec_o(1,1),eigenvec_o(2,1)];
comp2_o=10*[eigenvec_o(1,2),eigenvec_o(2,2)];

[eigenval_o2,eigenvec_o2]=pca_fun(dataOccluded2',2);
comp1_o2=10*[eigenvec_o2(1,1),eigenvec_o2(2,1)];
comp2_o2=10*[eigenvec_o2(1,2),eigenvec_o2(2,2)];

figure, 
plot(data(:,1),data(:,2),'*','color', [.5 .5 .5])%gray color in vector
hold on
quiver(gc(1),gc(2),comp1(1),comp1(2))
quiver(gc(1),gc(2),comp2(1),comp2(2))

title 'whole data'

figure, 
plot(dataOccluded(:,1),dataOccluded(:,2),'*','color', [.5 .5 .5])%gray color in vector
hold on
quiver(gc_o(1),gc_o(2),comp1_o(1),comp1_o(2))
quiver(gc_o(1),gc_o(2),comp2_o(1),comp2_o(2))
%   plot a red line that highlights the perimeter of the point cloud
plot(dataOccluded(kIndex,1),dataOccluded(kIndex,2),'r-','LineWidth',2)
title 'occluded data 1'
return




% figure, 
% plot(dataOccluded2(:,1),dataOccluded2(:,2),'*','color', [.5 .5 .5])%gray color in vector
% hold on
% quiver(gc_o2(1),gc_o2(2),comp1_o2(1),comp1_o2(2))
% quiver(gc_o2(1),gc_o2(2),comp2_o2(1),comp2_o2(2))
% title 'occluded data 2'