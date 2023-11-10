clc
close all
clear

% load matGlobalBoxesFigures.mat
load matGlobalBoxesFigures.mat;
sessionID=10;
fc='b';
figure,
myPlotBoxContour(globalBoxes,sessionID,fc)
myPlotPlanes_v3(globalPlanes.values(group_tpp(2)),1);
camup([0 1 0])
axis square
grid on
xlabel x
ylabel y
zlabel z

dibujarsistemaref(eye(4),'h',250,2,10,'k')