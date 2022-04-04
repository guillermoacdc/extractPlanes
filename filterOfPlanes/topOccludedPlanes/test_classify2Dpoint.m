clc
close all
clear

A=[-5,5];
B=[4,-3.5];
P=[-1,1];

classify2DpointwrtLine(A,B,P)

figure
plot([A(1) B(1)],[A(2) B(2)],'b-')
hold on
plot([P(1) ],[P(2) ],'k*')