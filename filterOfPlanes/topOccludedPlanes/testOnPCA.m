clc
close all 
clear

%% crear datos 2D alineados con ejes x y
% spatialSamplingRate=0.01;%10mm
% L1=0.25;%25cm
% L2=0.4;%40cm
spatialSamplingRate=1;%1mm
L1=10;%25cm
L2=7;%40cm

x=0:spatialSamplingRate:L1;
y=0:spatialSamplingRate:L2;

% data=ones(length(x)*length(y),2);
k=1;
for(i=1:length(x))
    for (j=1:length(y))
        data(k,:)=[i j];
        k=k+1;
    end
end

return
%% crear versión ocluida
% rebanada
for i=1:length(data)/2
    dataOccluded(i,:)=data(i,:);
end
dataOccluded=[dataOccluded; data(end,:)];

% tipo L


% diagonal ppal

%% rotar datos completos y ocluidos
theta=-45*pi/180;
R=[cos(theta) -sin(theta); sin(theta) cos(theta)];
for(i=1:size(data,1))
    data(i,:)=R*data(i,:)';
end
gc=[mean(data(:,1)), mean(data(:,2))];

for(i=1:size(dataOccluded,1))
    dataOccluded(i,:)=R*dataOccluded(i,:)';
end
gc_o=[mean(dataOccluded(:,1)), mean(dataOccluded(:,2))];
%% aplicar pca y comparar graficamente
[eigenval,eigenvec]=pca_fun(data',2);
comp1=10*[eigenvec(1,1),eigenvec(2,1)];
comp2=10*[eigenvec(1,2),eigenvec(2,2)];

[eigenval_o,eigenvec_o]=pca_fun(dataOccluded',2);
comp1_o=10*[eigenvec_o(1,1),eigenvec_o(2,1)];
comp2_o=10*[eigenvec_o(1,2),eigenvec_o(2,2)];

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
title 'occluded data'