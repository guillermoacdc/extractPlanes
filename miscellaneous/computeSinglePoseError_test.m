clc
close all
clear

T1=eye(4);
T2=T1;
T2(1:3,4)=[-100 0 -50]';
[et, er]=computeSinglePoseError(T2,T1)