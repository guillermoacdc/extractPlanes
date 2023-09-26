clc
close all
clear

% parameters
typeObject=1;% 1 for top, 2 for perpendicular
sessionID=10;

dataSetPath=computeMainPaths(1);

th_angle=45;
epsilon=100;
minpts=80;
th_distance=50;%mm
plotFlag=1;
th_distance2=2600;%distance btwn qm and limits of the workspace
kf=loadKeyFrames(dataSetPath,sessionID);
Nf=length(kf);
numberOfObjects=zeros(Nf,1);
for i=1:Nf
    frameID=kf(i);
    numberOfObjects(i)=countObjectsInPC_v2(sessionID, frameID, typeObject,...
    th_angle, th_distance, th_distance2, epsilon, minpts, plotFlag);
    display(['processing frame ' num2str(frameID)])
end

% write Results