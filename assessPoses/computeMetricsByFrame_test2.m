clc
close all
clear

sessionID=10;
[dataSetPath,evalPath,PCpath] = computeMainPaths(sessionID);
theta=0.6;
tao=50;


keyFrames=loadKeyFrames(dataSetPath,sessionID);
Nkeyframes=length(keyFrames);
% read json file
fileName='estimatedPoses.json';
jsonpath=fullfile(evalPath,['session' num2str(sessionID)], fileName);
    fid = fopen(jsonpath); 
    raw = fread(fid,inf); 
    str = char(raw'); 
    fclose(fid); 
    estimatedPoses = jsondecode(str);

DP_v=zeros(Nkeyframes,1);
DPm_v=zeros(Nkeyframes,1);
precision_v=zeros(Nkeyframes,1);
recall_v=zeros(Nkeyframes,1);

for i=1:Nkeyframes
    frameID=keyFrames(i);
    pps=getPPS(dataSetPath,sessionID,frameID);
    % extract estimations of an specific frame
    estimatedPose=estimatedPoses.(['frame' num2str(frameID)]);
    if ~isempty(estimatedPose)
        [DP, DPm, precision, recall] = computeMetricsByFrame(estimatedPose,theta,tao, pps);
    else
        continue
    end
    DP_v(i)=DP;
    DPm_v(i)=DPm;
    precision_v(i)=precision;
    recall_v(i)=recall;
end


figure,
stem(keyFrames,precision_v)
xlabel 'frames'
ylabel 'precision'
grid
title (['Tao=' num2str(tao) ' Theta=' num2str(theta)])

figure,
stem(keyFrames,recall_v)
xlabel 'frames'
ylabel 'recall'
grid
title (['Tao=' num2str(tao) ' Theta=' num2str(theta)])