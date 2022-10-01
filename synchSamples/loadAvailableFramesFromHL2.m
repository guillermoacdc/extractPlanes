function keyframes=loadAvailableFramesFromHL2(rootPath,scene)
%LOADAVAILABLEFRAMESFROMHL2 Summary of this function goes here
%   Detailed explanation goes here

fileName=rootPath  + 'scene' + num2str(scene) + '\Depth Long Throw_rig2world.txt';
rig2W=load(fileName);
keyframes=1:size(rig2W,1);
end

