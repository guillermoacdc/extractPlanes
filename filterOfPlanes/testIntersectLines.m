clc
close all
clear

Px=[-2 -2];
u=[0.7071 0.7071];
Pa=[-1.8 -2.1];
Pb=[-1.9 -2.3];






% Pa=[0 2.5];
% Pb=[2 0];
% Pa=Px;
% Pb=u;
% Px: geometric center of the 2D pointcloud
% u: 2d vector with angle alpha; alpha goes from 0 to pi
% Pa: point a of the convex hull
% Pb: point b of the convex hull

[out pc]=intersect_lines(Px, u, Pa, Pb);

figure,
    plot([Px(1) u(1)],[Px(2) u(2)],'Color','k','LineStyle','--')
    hold on
    plot([Pa(1) Pb(1)],[Pa(2) Pb(2)],'Color','b','LineStyle','--')
    plot(pc,'yo')
    xlabel 'x'
    ylabel 'y'
    grid