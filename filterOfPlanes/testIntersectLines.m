clc
close all
clear

p1=[1 3];
p2=[1 0];
p3=[1 -1];
p4=[1 -2];
% p3=[0 2.5];
% p4=[2 0];
% p3=p1;
% p4=p2;

[out pc]=intersect_lines(p1, p2, p3, p4);

figure,
    plot([p1(1) p2(1)],[p1(2) p2(2)],'Color','k','LineStyle','--')
    hold on
    plot([p3(1) p4(1)],[p3(2) p4(2)],'Color','b','LineStyle','--')
    plot(pc,'yo')
    xlabel 'x'
    ylabel 'y'