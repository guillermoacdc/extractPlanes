clc
close all
clear

R1=eye(3);
R2=rotz(90)*R1;
er=computeRotationError(R1,R2)
