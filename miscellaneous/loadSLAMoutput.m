function [pc_mm, T]=loadSLAMoutput(scene,frame,rootPath)
%LOADSLAMOUTPUT Summary of this function goes here
%   Detailed explanation goes here
[rootPath, ~, PCpath]=computeMainPaths(scene);
pathCamera=[rootPath + ['\corrida' num2str(scene) '\HL2\'] ];
pathPoints=[pathCamera + [ 'PointClouds\frame' num2str(frame) '.ply'] ];
% Load pc

pc = pcread(pathPoints);%in [mt]; indices begin at 0
% convert lengths to mm
    xyz=pc.Location*1000;
    pc_mm=pointCloud(xyz);

%  load T
cameraPoses=importdata([pathCamera + 'Depth Long Throw_rig2world.txt']);
cameraPoses=cameraPoses(frame,:);
T=assemblyTmatrix(cameraPoses(2:13));
T(1:3,4)=T(1:3,4)*1000;%conversion to mm

end

