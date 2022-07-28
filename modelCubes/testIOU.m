clc
close all
clear all

% create the rectangle A
% A.x1=10;
% A.y1=10;
% A.x2=15;
% A.y2=20;
A.x1=-20;
A.y1=15;
A.x2=-15;
A.y2=20;
% create the rectangle B
B.x1=10;
B.y1=10;
B.x2=15;
B.y2=20;
% compute IOU
IoU=computeIOU(A,B);
% plot