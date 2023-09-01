clc
close all
clear
% parameters
sessionID=12;
dataSetPath=computeMainPaths(sessionID);
planeGroup=0;%&for top planes
frame=1;
% load initial pose
planeDesc_m=loadInitialPose_v3(dataSetPath,sessionID,frame,planeGroup);
% compute Tm2h
Th2m=loadTh2m(dataSetPath,sessionID);
Tm2h=inv(Th2m);
% project poses
planeDesc_h=projectPose(planeDesc_m,Tm2h);
% plot
Nb=size(planeDesc_h,2);
figure,
for i =1:Nb
    T=planeDesc_h(i).tform;
    ind=planeDesc_h(i).idBox;
    dibujarsistemaref(T,ind,120,2,10,'b')
    hold on
end
axis square
xlabel 'x'
ylabel 'y'
zlabel 'z'
grid
