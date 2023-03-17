function [val] = getJSONData(rootPath,scene)
%GETJSONDATA Returns basic data in json file from mocap
%   Detailed explanation goes here
    
    append=computeAppendMocapFileName(scene);
    fileName=['corrida' num2str(scene) '-00' num2str(append)];
    display(['Processing scene ' num2str(scene) '. Filename:' fileName])
%     jsonpath = fullfile(rootPath + 'scene' + num2str(scene) + '\mocap\',[fileName '.rpd.json']);
    jsonpath = fullfile(rootPath + 'corrida' + num2str(scene) + '\mocap\',[fileName '.rpd.json']);
    
    fid = fopen(jsonpath); 
    raw = fread(fid,inf); 
    str = char(raw'); 
    fclose(fid); 
    val = jsondecode(str);
end