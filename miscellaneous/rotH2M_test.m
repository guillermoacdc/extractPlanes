clc
close all
clear

Th=[0 0 1 0; 1 0 0 0; 0 1 0 0; 0 0 0 1];
Tm=rotH2M(Th);
figure,
dibujarsistemaref(Th,'h',1,2,10,'k')
xlabel x
ylabel y
zlabel z
grid on

figure,
dibujarsistemaref(Tm,'m',1,2,10,'k')
xlabel x
ylabel y
zlabel z
grid on
