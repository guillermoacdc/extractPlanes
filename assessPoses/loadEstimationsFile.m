function estimatedPoses = loadEstimationsFile(fileName,sessionID, evalPath)
%LOADESTIMATIONSFILE Summary of this function goes here
%   Detailed explanation goes here
% fileName='estimatedPoses.json';
jsonpath=fullfile(evalPath,['session' num2str(sessionID)], fileName);
    fid = fopen(jsonpath); 
    raw = fread(fid,inf); 
    str = char(raw'); 
    fclose(fid); 
%     estimatedPoses = jsondecode(str);
    estimatedPoses = mps.json.decode(str);
end

