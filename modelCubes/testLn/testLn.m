clc
close all
clear

p1=[7 -3 0]';
p2=[3 -7 0]';
p=p1-p2;

figure,
dibujarlinea(p1, p2, 'r',2)
hold on
dibujarlinea([0 0 0]', p, 'b',2)
grid
view(2)