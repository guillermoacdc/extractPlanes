clc
close all
clear all


R2=eye(3);
R1=R2*rotx((pi)*180/pi);

er=acos((trace(R1'*R2)-1)/2)*180/pi