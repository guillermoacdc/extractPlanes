function Tc_m=loadTcmCandidates(scene, rootPath, minSample, maxSample, step)
%LOADTCMCANDIDATES Summary of this function goes here
%   Detailed explanation goes here

fileName = ['\rig2Mocap_sample'  num2str(minSample)  '_to' num2str(maxSample)  '_step_'  num2str(step) '.txt'];
% fileName = ['\rig2Mocap_frame'  num2str(keyframe_h)  '_band' num2str(band)  '_scale_'  num2str(scale) '.txt'];
filePath= [rootPath + 'scene' + num2str(scene) + fileName];
Tc_m=load(filePath);
Tc_m=Tc_m(:,2:end);
% fileName=rootPath  + 'scene' + num2str(scene) + '\rig2Mocap_1fps.txt';
% Tc_m=load(fileName);
% T=assemblyTmatrix(rig2M(frame,2:14));%distances in mm
end

