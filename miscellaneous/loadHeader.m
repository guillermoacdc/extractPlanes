function header=loadHeader(dataSetPath,sessionID)
%LOADHEADER Summary of this function goes here
%   Detailed explanation goes here

    fileName='sessionDescriptor.csv';
    filePath=fullfile(dataSetPath, ['session' num2str(sessionID)], 'filtered', 'MoCap');
    initialPosesT= importdata(fullfile(filePath,fileName));
    header = table(initialPosesT(1,:));

end

