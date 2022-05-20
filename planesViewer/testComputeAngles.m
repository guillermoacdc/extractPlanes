clc
close all
clear 

% prepara vectores con ángulo predefinido theta
v1=[1 0 0];
% rotación de theta grados alrededor del eje y
% theta=10*pi/180;
%     A = [1 0 0 0; ...
%         0 cos(theta) -sin(theta) 0;...
%         0 sin(theta) cos(theta) 0;...
%         0 0 0 1];
theta=185;
A=eye(4);
A(1:3,1:3)=roty(theta);

v1a=[v1 1];    
v2=A*v1a';
v2=v2(1:end-1);
% calcula angulo
theta2=computeAngleBtwnVectors(v1,v2');%returns values in the closed interval [-180,180]

% grafica
figure,
quiver3(0,0,0,v1(1),v1(2),v1(3))
hold on
quiver3(0,0,0,v2(1),v2(2),v2(3))
xlabel 'x (m)'
ylabel 'y (m)'
zlabel 'z (m)'
title (['compare angles. Expected: ' num2str(theta) '. Computed: ' num2str(theta2)])
% Conclusiones
% 1. Se pierde el signo del ángulo en casos de ángulos negativos.
% 2. Fallas en ángulos por fuera del rango [-180,180], ejemplo
%       theta=190; theta2=170
% Análisis punto 2. La fuente del problema está en la transformación,
% cuando le pides rotar 190, termina rotando 170