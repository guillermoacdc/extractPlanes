function T=loadInitialPoseHL2(rootPath,scene)
%LOADINITIALPOSEHL2 Summary of this function goes here
%   Detailed explanation goes here

% T is available in the file rootPath/scenex/rig2mocap_1fps.txt 
fileName=rootPath  + 'scene' + num2str(scene) + '\rig2Mocap_1fps.txt';
rig2M=load(fileName);
T=assemblyTmatrix(rig2M(1,2:14));
end

