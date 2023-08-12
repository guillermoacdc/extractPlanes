clc
close all
clear 
% compara las alturas gt vs las altura reales de cada caja en la sesión.
% Asume que las sesiones no poseen apilamiento

sessionID=32;
frameID=1;
syntheticPlaneType=0;
dataSetPath=computeMainPaths(sessionID);
gtPlanes=loadInitialPose_v3(dataSetPath,sessionID,frameID,syntheticPlaneType);

N=size(gtPlanes,2);
h_gt=zeros(N,1);
boxID=zeros(N,1);
xLocation=zeros(N,1);
yLocation=zeros(N,1);
for i=1:N
    h_gt(i)=gtPlanes(i).tform(3,4);
    boxID(i)=gtPlanes(i).idBox;
    xLocation(i)=gtPlanes(i).tform(1,4);
    yLocation(i)=gtPlanes(i).tform(2,4);
end
h_real=loadBoxHeight(boxID,dataSetPath);
% compute error
h_e=abs(h_gt-h_real);


bubblechart(xLocation,yLocation,h_e) 
bubblelegend('h_e (mm)','Location','eastoutside')
title (['height error in boxes, session ' num2str(sessionID)])
return




figure,
    stem(h_e)
    xticks(1:N)
    xticklabels(boxID)
    xlabel 'box ID'
    ylabel 'h_{error}=h_{gt}-h_{real}'
    title (['height error in boxes, session ' num2str(sessionID)])