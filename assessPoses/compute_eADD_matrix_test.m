clc
close all
clear

sessionID=12;
tao=50;
NpointsDiagPpal=40;
planesGroup=0;
fileName_estimations=['estimatedPoses_qh_planeType' num2str(planesGroup) '.json'];



[eADD_m] = compute_eADD_matrix(sessionID, tao, NpointsDiagPpal,...
    fileName_estimations, planesGroup);
return
% removing warnings
w = warning('query','last');
id=w.identifier;
warning('off',id)