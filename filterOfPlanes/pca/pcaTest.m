clc
close all
clear

%% carga de datos
N=1000;
u=[0 0]';
sigmax=2;
sigmay=1;
% sigma = [1 0.5; 0.5 2];
sigma = [sigmax^2 0.5; 0.5 sigmay^2];
x = mvnrnd(u,sigma,N)'; %data set Clase 1

%% cálculo componentes ppales

% [eigenval,eigenvec]=pca_fun(x,2);
[eigenval,eigenvec]=pca_fun(pcaData,2);

figure,
plot(x(1,:),x(2,:),'bo')
hold
comp1=eigenval(1)*[eigenvec(1,1),eigenvec(2,1)];
comp2=eigenval(2)*[eigenvec(1,2),eigenvec(2,2)];
quiver(0,0,comp1(1),comp1(2))
quiver(0,0,comp2(1),comp2(2))

quiver(planeDescriptor.geometricCenter(1),planeDescriptor.geometricCenter(3),comp1(1),comp1(2))
quiver(planeDescriptor.geometricCenter(1),planeDescriptor.geometricCenter(3),comp2(1),comp2(2))

xlabel 'x'
ylabel 'y'



return
% calculo matriz de covarianza c
c=cov(x);
% cálculo de autovalores (landa) y autovectores unitarios (e) de c
[landa 	e]=eig(c);





