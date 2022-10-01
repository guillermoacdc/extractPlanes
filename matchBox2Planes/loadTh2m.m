function T = loadTh2m(rootPath,scene)
%LOADTH2M Summary of this function goes here
%   Detailed explanation goes here

% T is available in the file rootPath/scenex/Th2m.txt 
fileName=rootPath  + 'scene' + num2str(scene) + '\Th2m.txt';
Tplane=load(fileName);
T=assemblyTmatrix(Tplane);%transformation matrix with lengths in mm
end

