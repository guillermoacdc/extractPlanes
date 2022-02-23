clc
close all
clear all

myalpha=linspace(-pi,pi,359)
myx=cos(myalpha);%input in radians
myy=sin(myalpha);

mym=myy./myx;

figure,
plot(myalpha*180/pi,mym)
xlabel 'alpha'
ylabel 'slope (m)'
grid