function [pc_mm, T]=loadSLAMoutput_v2(scene,frame,rootPath)
%LOADSLAMOUTPUT Summary of this function goes here
%   Detailed explanation goes here
[rootPath, ~, PCpath]=computeMainPaths(scene);

fileNameCamera='Depth Long Throw_rig2world.txt';
fileNamePoints=['frame' num2str(frame) '.ply'];
pathCamera=fullfile(rootPath,['session' num2str(scene)],'raw','HL2',fileNameCamera);
pathPoints=fullfile(PCpath,['corrida' num2str(scene)],fileNamePoints);
% pathCamera=[rootPath + ['\corrida' num2str(scene) '\HL2\'] ];
% pathPoints=[pathCamera + [ 'PointClouds\frame' num2str(frame) '.ply'] ];
% Load pc

% pc = pcread(pathPoints);%in [mt]; indices begin at 0
% % convert lengths to mm
%     xyz=pc.Location*1000;
%     pc_mm=pointCloud(xyz);
pc_mm=0;

%  load T
cameraPoses=importdata(pathCamera);
cameraPoses=cameraPoses(frame,:);
T=assemblyTmatrix(cameraPoses(2:13));
T(1:3,4)=T(1:3,4)*1000;%conversion to mm

end

