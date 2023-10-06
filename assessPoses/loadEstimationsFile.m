function estimatedPoses = loadEstimationsFile(fileName,sessionID, evalPath)
%LOADESTIMATIONSFILE Summary of this function goes here
%   Detailed explanation goes here
% fileName='estimatedPoses.json';

windowsFlag=false;
old=filesep;
if old=='\'
    windowsFlag=true;
end

jsonpath=fullfile(evalPath,['session' num2str(sessionID)], fileName);
    fid = fopen(jsonpath); 
    raw = fread(fid,inf); 
    str = char(raw'); 
    fclose(fid); 
    if windowsFlag
%         estimatedPoses = mps.json.decode(str);
            estimatedPoses = jsondecode(str);
    else
        estimatedPoses = jsondecode(str);
    end
%     
    
end

