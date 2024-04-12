clc 
close all
clear 

% create plane objects for each side
boxID=0;
sessionID=10;
sidesVector=[1, 5];
frameHL2=25;
NpointsDiagTopSide=10;
gridStep=1;
H=250;
W=500;
D=400;
dataSetPath=computeReadPaths(sessionID);
boxLengths=[boxID H W D];%IdBox,Heigth(mm),Width(mm),Depth(mm)
% bug with boxLengths=[boxID 250 300 400];
planeDescriptor = convertPK2PlaneObjects_vref(boxID,sessionID, ...
    sidesVector, boxLengths);
% create synthetic pc
pc=createSyntheticPC_vref(planeDescriptor,NpointsDiagTopSide, gridStep, boxLengths);



% recompute R to plot coordinate systems
% top plane
Ttop=planeDescriptor(1).tform;
Rtemp=Ttop(1:3,1:3);
% Rtemp=rotz(90)*Rtemp;%rotz 90°
% Rtop=rotx(90)*Rtop;
Ttop(1:3,1:3)=Rtemp;
figure,

    pcshow(pc)
%     hold on
%     dibujarsistemaref(Ttop,boxID,150,2,10,'w');
%     hold on
%     dibujarsistemaref(planeDescriptor(2).tform,boxID,150,2,10,'w');
%     hold on
%     dibujarsistemaref(planeDescriptor(3).tform,boxID,150,2,10,'w');
    hold on
    myPlotPlanes_Anotation(planeDescriptor,0,'m','w')
   hold on






T1=eye(4);%top
T1(1:3,1:3)=roty(90)*rotz(90)*T1(1:3,1:3);
T2=T1;%front--2
T2(1:3,1:3)=roty(90)*[0 -1 0; 0 0 1; -1 0 0];
T2(1:3,4)=[0 W/2 -H/2]';

T3=T1;%right--1
T3(1:3,1:3)=rotx(90)*[0 0 1; 0 1 0; -1 0 0];
T3(1:3,4)=[D/2 0 -H/2]';

T4=T1;%back
T4(1:3,1:3)=[0 1 0; 0 0 -1; -1 0 0];
T4(1:3,4)=[0 -W/2 -H/2]';

T5=T1;%left
T5(1:3,1:3)=[0 0 -1; 0 -1 0; -1 0 0];
T5(1:3,4)=[-D/2 0 -H/2]';

return
% figure,
dibujarsistemaref(T1, '0', 150, 2 , 8 , 'w')
hold on
dibujarsistemaref(T2, '2', 150, 2 , 8 , 'w')
dibujarsistemaref(T3, '1', 150, 2 , 8 , 'w')
% dibujarsistemaref(T4, 'back', 150, 2 , 8 , 'b')
% dibujarsistemaref(T5, 'left', 150, 2 , 8 , 'b')
grid
xlabel 'x'
ylabel 'y'
zlabel 'z'
axis