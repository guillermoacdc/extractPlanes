function timeStamps = loadAvailableTimeStampsH(rootPath,scene)
%LOADAVAILABLETIMESTAMPSH Summary of this function goes here
%   Detailed explanation goes here


fileName=rootPath  + 'scene' + num2str(scene) + '\Depth Long Throw_rig2world.txt';
rig2W=load(fileName);
timeStamps=uint64(rig2W(:,1));
end