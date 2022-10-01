clc
close all
clear all
% mocap frame
qm=eye(4);
% qm(1:3,4)=[1 0 0]';
% transformation matrix
% Tm2h=eye(4);
% Tm2h(1:3,1:3)=[0 0 1;1 0 0;0 1 0];
% Tm2h=rotz(90);
% hololens frame
% qh=[0 1 0 0;-1 0 0 0;0 0 1 0; 0 0 0 1];
qh=eye(4);
qh(1:3,1:3)=rotz(90);
% qh=qm*Tm2h;%post multiplying 
% qh=Tm2h*qm;%pre multiplying 
% when pre-multiplying doesnt keep the translation vector info
% when pos-multiplying keeps the translation vector info
[et,er, et_xyz]=computeSinglePoseError(qm,qh)

figure,
dibujarsistemaref(qm,'m',10,2,10,'b');
hold on
dibujarsistemaref(qh,'h',5,2,10,'b');
grid on