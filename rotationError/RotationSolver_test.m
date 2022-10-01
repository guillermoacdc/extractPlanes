clc
close all
clear all

% define R2,R1
R2=eye(3);
R1=rotx(-20);
R=myRotationSolver(R1,R2);
% conversion from roation matrix to euler angles
eul=rotm2eul(R);%returns Euler rotation angles in radians
% sort output angles by sequence x, y, z, and convert to degrees
[eul(3) eul(2) eul(1)]*180/pi