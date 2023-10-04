clc
close all
clear


sessionID=10;
frameID=144;
tao=50;
theta=0.5;
NpointsDiagPpal=30;
planeType=1;
% kfindex=15;%15 para frame 12; 35 para

%% load gt planes
gtPlanes=loadGTPlanes(sessionID,frameID);
gtPlanesID=extractIDsFromVector(gtPlanes);
Ngtplanes=size(gtPlanesID,1);
idx=find(gtPlanesID(:,2)==1);
if planeType==0 %top planes
% delete lateral planes
    idxs=[1:Ngtplanes];
    idx=setdiff(idxs,idx);
    gtPlanes(idx)=[];
else
% delete top planes
    gtPlanes(idx)=[];
end

%% load estimations
fileName=['estimatedPoses_ia_planeType' num2str(planeType) '.json'];
[dataSetPath,evalPath]=computeMainPaths(sessionID);
estimatedPoses = loadEstimationsFile(fileName,sessionID, evalPath);
globalPlanes=estimatedPoses.(['frame' num2str(frameID)]);
%% compute metrics by frame
[TPhl2, TPm, FPhl2, FNm] = computeMetricsByFrame_v3(globalPlanes, sessionID, ...
    frameID, gtPlanes, tao, theta, NpointsDiagPpal, planeType);
TPhl2
TPm
FPhl2
FNm


% plot estimated and gt poses in qm--solve saving of pathPoints to enable
% this section
figure,
    plotEstimationsByFrame_v2(globalPlanes.values, planeType, sessionID, frameID);%script