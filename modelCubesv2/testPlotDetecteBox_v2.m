clc
close all
clear

% load matGlobalBoxesFigures.mat
load matGlobalBoxesFigures.mat;
sessionID=10;
fc='b';
myPlotBoxContour(globalBoxes,sessionID,fc)

camup([0 1 0])
axis square
grid on
xlabel x
ylabel y
zlabel z

dibujarsistemaref(eye(4),'h',250,2,10,'k')