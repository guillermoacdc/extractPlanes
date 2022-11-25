function [Traw time] = loadTh_c(rootPath,scene,frame)
%LOADTH_C Load Transformation from camera to qh for an specific frame


% T is available in the file rootPath/scenex/Depth Long Throw_rig2world.txt 
% fileName=rootPath  + 'scene' + num2str(scene) + '\Depth Long Throw_rig2world.txt';
fileName=rootPath  + 'corrida' + num2str(scene) + '\Depth Long Throw_rig2world.txt';
rig2W=load(fileName);
% convert frame to index
% %   load available keyframes
% keyFrames=loadKeyFrames(rootPath,scene);
% %   look for the frame in the available index
% index=find(keyFrames==frame);
time=rig2W(frame,1);
Traw=assemblyTmatrix(rig2W(frame,2:14));%distances in mt
% conversion of distances to mm
Traw(1:3,4)=Traw(1:3,4)*1000;% we kept the rotations vector because those are unitary

