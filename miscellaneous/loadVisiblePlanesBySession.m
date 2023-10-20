function visiblePlanesBySession = loadVisiblePlanesBySession(fileName,sessionID)
%LOADVISIBLEPLANES Summary of this function goes here
%   Detailed explanation goes here
% dataSetPath=computeMainPaths(sessionID);
dataSetPath=computeReadPaths(sessionID);
jsonpath=fullfile(dataSetPath,['session' num2str(sessionID)], 'analyzed',...
    'HL2', fileName);
    fid = fopen(jsonpath); 
    raw = fread(fid,inf); 
    str = char(raw'); 
    fclose(fid); 
%     visiblePlanesBySession = mps.json.decode(str);
        visiblePlanesBySession = jsondecode(str);
    
end