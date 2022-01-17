clc
close all
clear all

folderpath="G:\Mi unidad\semestre 6\1-3 AlgoritmosSeguimientoPose\PCL\sc5frame2\";
filename="132697151403874938.pgm";

I=imread([ folderpath + filename]);
imshow(I,[])

% datos diferentes de cero en I
k=find(I);
length(k)