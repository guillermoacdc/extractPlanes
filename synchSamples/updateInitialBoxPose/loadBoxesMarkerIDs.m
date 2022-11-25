function [boxesIDs, markerIDs ] = loadBoxesMarkerIDs(scene,rootPath)
%LOADBOXESMARKERIDS Summary of this function goes here
%   Detailed explanation goes here
boxesIDs=0;
markerIDs=0;
filename=rootPath+'misc\'+'Aleatorizacionv5.xlsx';
append=computeAppend(scene);
if append==1
    sheetName=['corrida' num2str(scene) ];
else
    sheetName=['corrida' num2str(scene) '-00' num2str(append)];
end

data=readtable(filename,'Sheet',sheetName);
qBoxes=table2array(data(1,16));
markerIDs=table2array(data(4:(4+qBoxes-1),13));
boxesIDs=table2array(data(4:(4+qBoxes-1),16));
end

