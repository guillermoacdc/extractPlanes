function jsonData = loadJSONfile(fileName, evalPath)
%LOADJSONFILE Summary of this function goes here
%   Detailed explanation goes here
% fileName='jsonData.json';
jsonpath=fullfile(evalPath, fileName);
    fid = fopen(jsonpath); 
    raw = fread(fid,inf); 
    str = char(raw'); 
    fclose(fid); 
%     jsonData = jsondecode(str);
    jsonData = mps.json.decode(str);
end

