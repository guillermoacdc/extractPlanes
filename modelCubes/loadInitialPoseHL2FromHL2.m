function T=loadInitialPoseHL2FromHL2(rootPath,scene, frame)
%LOADINITIALPOSEHL2FROMHL2 Loads camera pose in hololens world
%   Returns distance in mm and angle in degrees


if nargin==2
    frame=1;
end

% T is available in the file rootPath/scenex/Depth Long Throw_rig2world.txt 
fileName=rootPath  + 'scene' + num2str(scene) + '\Depth Long Throw_rig2world.txt';
rig2W=load(fileName);
Th=assemblyTmatrix(rig2W(frame,2:14));%distances in mt
% conversion of distances to mm
T=Th;
T(1:3,4)=T(1:3,4)*1000;
end

