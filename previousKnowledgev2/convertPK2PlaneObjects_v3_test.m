clc
close all
clear


dataSetPath='D:\6DViCuT_p1';
sessionID=10;
planeType=0;
frameHL2=101;
boxID=getPPS(dataSetPath,sessionID,frameHL2);
% boxID=30;
planeDescriptor = convertPK2PlaneObjects_v3(dataSetPath,sessionID,planeType, frameHL2, boxID);