clc
close all
clear

frameID=15;
sessionID=10;
[dataSetPath,evalPath,PCpath] = computeMainPaths(sessionID);
theta=0.6;
tao=50;
pps=getPPS(dataSetPath,sessionID,frameID);

% read json file
fileName='estimatedPoses.json';
jsonpath=fullfile(evalPath,['session' num2str(sessionID)], fileName);
    fid = fopen(jsonpath); 
    raw = fread(fid,inf); 
    str = char(raw'); 
    fclose(fid); 
    estimatedPoses = jsondecode(str);
% extract estimations of an specific frame
estimatedPose=estimatedPoses.(['frame' num2str(frameID)]);

[DP, DPm, precision, recall] = computeMetricsByFrame(estimatedPose,theta,tao, pps);