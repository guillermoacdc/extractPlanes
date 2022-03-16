clc
close all
clear 

%% prepara caja con médida estándar; se asume caja en origen de sis ref
Z=5;%height
X=4;%width
Y=3;%depth


[f1 f2 f3] = createBoxPCv4(X,Y,Z);

p0=computeIntersectionBtwn3Planes(f1.geometricCenter, f2.geometricCenter,...
    f3.geometricCenter, f1.planeParameters(1:3)', f2.planeParameters(1:3)',...
    f3.planeParameters(1:3)')



%% grafica

figure,
surf(f1.x,f1.y,f1.z,'FaceAlpha',0.5) %Plot the surface
hold on
surf(f2.x,f2.y,f2.z,'FaceAlpha',0.5) %Plot the surface
surf(f3.x,f3.y,f3.z,'FaceAlpha',0.5) %Plot the surface

quiver3(f1.geometricCenter(1),f1.geometricCenter(2),...
    f1.geometricCenter(3),f1.planeParameters(1),...
    f1.planeParameters(2),f1.planeParameters(3))%
hold on
quiver3(f2.geometricCenter(1),f2.geometricCenter(2),...
    f2.geometricCenter(3),f2.planeParameters(1),...
    f2.planeParameters(2),f2.planeParameters(3))%

quiver3(f3.geometricCenter(1),f3.geometricCenter(2),...
    f3.geometricCenter(3),f3.planeParameters(1),...
    f3.planeParameters(2),f3.planeParameters(3))%

plot3(p0(1),p0(2),p0(3),'*b','LineWidth',3)

xlabel 'x '
ylabel 'y '
zlabel 'z '
view(130,45)
