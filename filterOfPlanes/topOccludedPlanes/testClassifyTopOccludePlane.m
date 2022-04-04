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
%% rotar datos completos y ocluidos
theta=50*pi/180;
% [data gc] = my2DRot(data,theta);
[dataOccluded gc_o] = my2DRot(dataOccluded,theta);

% Find AB points
[A B]=findPartitionLine(dataOccluded);

return

A=[-10,50];
B=[5,15];

figure, 
plot(dataOccluded(:,1),dataOccluded(:,2),'*','color', [.5 .5 .5])%gray color in vector
hold on
plot([A(1) B(1)],[A(2) B(2)],'b-')
grid on
title 'occluded data'

% group data in two categories: dataS1, dataS2
k1=1;
k2=2;
for (i=1:size(dataOccluded,1))
    testResult=classify2DpointwrtLine(A,B,dataOccluded(i,:));
    if (testResult==0)
        dataS1(k1,:)=dataOccluded(i,:);
        k1=k1+1;
    else
        dataS2(k2,:)=dataOccluded(i,:);
        k2=k2+1;
    end
end

figure, 
plot(dataS1(:,1),dataS1(:,2),'*','color', [.5 .5 .5])%gray color in vector
hold on
plot(dataS2(:,1),dataS2(:,2),'*','color', [.8 .5 .3])%x color in vector
plot([A(1) B(1)],[A(2) B(2)],'b-')
grid on
title 'occluded data'

return
