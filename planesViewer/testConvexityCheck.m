clc
close all
clear 

%% prepara caja con médida estándar; se asume caja en origen de sis ref
Z=2.5;%height
X=4;%width
Y=3;%depth


[f1 f2 f3] = createBoxPCv4(X,Y,Z);

%% prepara vectores con ángulo predefinido theta
% top vector
v1=[0 0 1];

% side vector
% rotación de theta grados alrededor del eje x
theta=90*pi/180;
    A = [1 0 0 0; ...
        0 cos(theta) -sin(theta) 0;...
        0 sin(theta) cos(theta) 0;...
        0 0 0 1];
v1a=[v1 1];    
v2=A*v1a';
v2=v2(1:end-1);
% calcula angulo
theta2=computeAngleBtwnVectors(v1,v2')%returns values in the closed interval [-180,180]
p1=[0,0,Z/2];
p2=[0,-Y/2,0];
%% calcula angulos a1, a2
p12=p1-p2;
alfa1=computeAngleBtwnVectors(p12, v1);
alfa2=computeAngleBtwnVectors(p12, v2);
convexityFlag=0;
if alfa1<alfa2
    convexityFlag=1;
end
%% grafica

figure,
surf(f1.x,f1.y,f1.z,'FaceAlpha',0.5) %Plot the surface
hold on
surf(f2.x,f2.y,f2.z,'FaceAlpha',0.5) %Plot the surface
surf(f3.x,f3.y,f3.z,'FaceAlpha',0.5) %Plot the surface

quiver3(p1(1),p1(2),p1(3),v1(1),v1(2),v1(3))%top vector
hold on
quiver3(p2(1),p2(2),p2(3),v2(1),v2(2),v2(3))%side vector

plot3([p1(1) p2(1)],[p1(2) p2(2)],[p1(3) p2(3)])

title (['Convexity check=' num2str(convexityFlag) '; \alpha_1=' num2str(alfa1) '; \alpha_2= ' num2str(alfa2)])

xlabel 'x '
ylabel 'y '
zlabel 'z '
% view(90,0)
