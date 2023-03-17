clc
close all
clear
acceptedPlanes=[ 1 1; 1 2; 1 3; 1 4; 1 5];
targetPlane=[1 1];
searchSpace = setdiff_v2(acceptedPlanes,targetPlane)