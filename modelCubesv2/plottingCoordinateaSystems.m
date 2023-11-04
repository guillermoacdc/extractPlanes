clc 
close all
clear 

Height=20;
Depth=30;
Width= 50;

T0=eye(4);
% right
T1=T0;
T1(1:3,1:3)=[1 0 0; 0 0 -1; 0 1 0];
T1(1:3,4)=[0 -Height/2 Depth/2]';
% front
T2=T0;
T2(1:3,1:3)=[0 1 0; 0 0 -1; -1 0 0];
T2(1:3,4)=[Width/2 -Height/2 0]';
% left
T3=T0;
T3(1:3,1:3)=[-1 0 0; 0 0 -1; 0 -1 0];
T3(1:3,4)=[0 -Height/2 -Depth/2]';
% back
T4=T0;
T4(1:3,1:3)=[0 -1 0; 0 0 -1; 1 0 0];
T4(1:3,4)=[-Width/2 -Height/2 0]';

figure,
dibujarsistemaref(T0, '0', 1, 2, 10 , 'k')
hold on
dibujarsistemaref(T1, 'right', 1, 2, 10 , 'k')
dibujarsistemaref(T2, 'front', 1, 2, 10 , 'k')
dibujarsistemaref(T3, 'left', 1, 2, 10 , 'k')
dibujarsistemaref(T4, 'back', 1, 2, 10 , 'k')
grid on
xlabel x
ylabel y
zlabel z
camup([0 1 0])