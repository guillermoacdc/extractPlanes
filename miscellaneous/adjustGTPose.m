clc
close all
clear
% box 13 at session 10
p1=[-796.837,2289.5,203.059]';
p2=[-867.879,2002.58,208.832]';

W=400;%box 13
H=250;
D=300;

A=0;
B=0;
C=1;

tform=computeTformBox(p1,p2,A,B,C,W,H,D);

p1p=projectSinglePoint2Plane(p1,A,B,C,-H);
p2p=projectSinglePoint2Plane(p2,A,B,C,-H);
[j_unit, p0] = compute_jvector_pc(p1p, p2p, A, B, C, W);
% compute vector paralle to axis x
i_unit=p1p-p2p;
i_unit=i_unit/norm(i_unit);

tform=eye(4);
tform(1:3,3)=[A B C]';
tform(1:3,2)=j_unit;
tform(1:3,1)=i_unit; %or cross([A B C]',j_unit);
tform(1:3,4)=p0;

figure,
plot3(p1(1),p1(2),p1(3),'bo');
hold on
plot3(p2(1),p2(2),p2(3),'bo');
dibujarsistemaref(tform,'b',150,2,10,'b')
grid
xlabel 'x'
ylabel 'y'
zlabel 'z'

