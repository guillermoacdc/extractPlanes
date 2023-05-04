clc
close all
clear

v1=[0 0 1]';
angles=0:10:180;

N=size(angles,2);

estimatedAngle=zeros(1,N);
for i=1:N
    myAngle=angles(i);
    v2=roty(myAngle)*v1;
    estimatedAngle(i)=computeAngleBtwnVectors(v1,v2);
end

figure,
subplot(211),...
    stem(angles)
    ylabel 'Reference angle'
    grid
subplot(212),...
    stem(estimatedAngle)
    ylabel 'Estimated angle'
    grid
    

% fitness plane function
fitness=zeros(1,N);
for i=1:N
    myAngle=angles(i)*pi/180;
    fitness(i)=(cos(myAngle)+1)/2;%angle in radians
end

figure,
    plot(angles,fitness)
    ylabel 'fitness'
    grid

