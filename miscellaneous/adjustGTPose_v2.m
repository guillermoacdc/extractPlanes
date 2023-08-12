clc
close all
clear
% box 13 at session 10
p1=[-796.837,2289.5,203.059]';
p2=[-867.879,2002.58,208.832]';
%box 13 size
W=400;
H=250;
D=300;%depth
% ideal ground normal
A=0;
B=0;
C=1;

tform1=computeTformBox(p1,p2,A,B,C,W,H,D);

% ground normal with slope
A=0.0071;
B=0.0253;
C=0.9997;

tform2=computeTformBox(p1,p2,A,B,C,W,H,D);

figure,
plot3(p1(1),p1(2),p1(3),'bo');
hold on
plot3(p2(1),p2(2),p2(3),'bo');
dibujarsistemaref(tform1,'b1',150,2,10,'b')
dibujarsistemaref(tform2,'b2',150,2,10,'r')
grid
xlabel 'x'
ylabel 'y'
zlabel 'z'


NpointsDiagTopSide=25;
numberOfSides=3;
% compute synthetic pc from current tform in dataset
dataSetpath=computeMainPaths(10);
temp_planeDescriptor=convertPK2PlaneObjects_v4(dataSetpath,10,1,2,13);
cplaneDescriptor.fr0.values(1)=temp_planeDescriptor;
cpcBox=createSyntheticPC(cplaneDescriptor,NpointsDiagTopSide, numberOfSides);
cpcBox_m=myProjection_v3(cpcBox{1},cplaneDescriptor.fr0.values(1).tform);

% compute synthetic pc from new tform
planeDescriptor.fr0.values(1).L1=D;
planeDescriptor.fr0.values(1).L2=W;
planeDescriptor.fr0.values(1).D=H;
planeDescriptor.fr0.values(1).tform=tform2;
pcBox=createSyntheticPC(planeDescriptor,NpointsDiagTopSide, numberOfSides);
pcBox_m=myProjection_v3(pcBox{1},planeDescriptor.fr0.values(1).tform);


figure,
    pcshow(cpcBox_m)
    hold
    dibujarsistemaref(eye(4),'m',150,2,10,'y')
    plot3(p1(1),p1(2),p1(3),'yo');
    hold on
    plot3(p2(1),p2(2),p2(3),'yo');
    xlabel 'x'
    ylabel 'y'
    zlabel 'z'
    title 'synthetic pc from current initial pose'

 figure,
    pcshow(pcBox_m)
    hold
    dibujarsistemaref(eye(4),'m',150,2,10,'y')
    plot3(p1(1),p1(2),p1(3),'yo');
    hold on
    plot3(p2(1),p2(2),p2(3),'yo');
    xlabel 'x'
    ylabel 'y'
    zlabel 'z'
    title 'synthetic pc from modified initial pose'


