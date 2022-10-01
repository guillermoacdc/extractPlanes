clc
close all
clear all
% mocap frame
qm=eye(4);
qm(1:3,4)=[1 0 0]';
% transformation matrix
Tm2h=eye(4);
Tm2h(1:3,1:3)=[0 0 1;1 0 0;0 1 0];
% hololens frame
qh=qm*Tm2h;%post multiplying 
% qh=Tm2h*qm;%pre multiplying 
% when pre-multiplying doesnt keep the translation vector info
% when pos-multiplying keeps the translation vector info
figure,
dibujarsistemaref(qm,'m',10,2,10,'b');
hold on
dibujarsistemaref(qh,'h',5,2,10,'b');
grid on