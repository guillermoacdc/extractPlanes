clc
close all
clear

algorithm=1;
sessionID=13;
[dataSetPath,evalPath,PCpath] = computeMainPaths(sessionID);
frameID=180; 
tao=50;
theta=0.5;
NpointsDiagTopSide=50;%used in the creation of synthetic point clouds
planeType=0;
fileName=['estimatedPoses_ia' num2str(algorithm) '_planeType' num2str(planeType) '.json'];
% if algorithm==1
%     fileName='estimatedPoses_ia1_v2.json';
% else
%     fileName='estimatedPoses_ia2_v2.json';
% end

eADD_m=plot_eADDByFrame(sessionID,frameID,tao,theta,evalPath,dataSetPath, PCpath,...
    NpointsDiagTopSide, planeType, fileName)