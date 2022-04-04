clc
close all
clear all


% Generate test data
%% crear datos 2D alineados con ejes x y
spatialSamplingRate=0.01;%10mm
L1=0.25;%25cm
L2=0.4;%40cm
data=build2DallignedData(L1,L2, spatialSamplingRate);
figure,
    plot(data(:,1),data(:,2),'*','color', [.5 .5 .5])%gray color in vector

% Generate the discrimination line AB
% A=[0 20];
% B=[25 20];

% A=[0 0];
% B=[25 40];

% A=[0 40];
% B=[25 0];

A=[12 0];
B=[12 40];

% Classify 
    k1=1;
    k2=1;
    for i=1:size(data,1)
         [class slope]=classify2DpointwrtLine_v2(A,B,data(i,:));
        if (class==0)
            dataS1(k1,:)=data(i,:);
            k1=k1+1;
        else
            dataS2(k2,:)=data(i,:);
            k2=k2+1;
        end
    end
% plot
figure,
    plot(dataS1(:,1),dataS1(:,2),'*','color', [.5 .5 .5])%gray color in vector
    hold on
    plot(dataS2(:,1),dataS2(:,2),'o','color', [.8 .8 .5])%gray color in vector
