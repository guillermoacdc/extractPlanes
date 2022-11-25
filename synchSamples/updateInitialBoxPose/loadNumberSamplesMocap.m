function [numberSamples] = loadNumberSamplesMocap(rootPath,scene)
%LOADNUMBERSAMPLESMOCAP Summary of this function goes here
%   Detailed explanation goes here
% 1. load init scanning time for mocap
append=computeAppend(scene);
fileName=['corrida' num2str(scene) '-00' num2str(append)];
% jsonpath = fullfile(rootPath + 'scene' + num2str(scene) + '\mocap\',[fileName '.rpd.json']);
jsonpath = fullfile(rootPath + 'corrida' + num2str(scene) + '\mocap\',[fileName '.rpd.json']);

fid = fopen(jsonpath); 
raw = fread(fid,inf); 
str = char(raw'); 
fclose(fid); 
val = jsondecode(str);
numberSamples=val.frames;

end

