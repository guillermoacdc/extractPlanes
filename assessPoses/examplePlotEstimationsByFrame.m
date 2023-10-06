clc
close all
clear

%% set parameters
sessionID=3;
frameID=409;
tao=50;
theta=0.5;
NpointsDiagPpal=30;
planeType=0;
outputFileName=['assessment_planeType' num2str(planeType) '.json'];
%% load estimations for all frames
inputFileName=['estimatedPoses_ia_planeType' num2str(planeType) '.json'];
[dataSetPath,evalPath]=computeMainPaths(sessionID);
estimatedPoses = loadEstimationsFile(inputFileName,sessionID, evalPath);

keyFrames=estimatedPoses.keyFrames;
Nkf=length(keyFrames);
%% iterative assessment by frame
% for i=1:Nkf
%     frameID=keyFrames(i);
    %load estimations in the current frame
    globalPlanes=estimatedPoses.(['frame' num2str(frameID)]);
    %% load gt planes for the current frame
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
    %% compute metrics by frame
    myLegend=['Asessing frame ' num2str(frameID) ];
    disp(myLegend)
    [TPhl2, TPm, FPhl2, FNm] = computeMetricsByFrame_v3(globalPlanes, sessionID, ...
        frameID, gtPlanes, tao, theta, NpointsDiagPpal, planeType);
    assessment.(['frame' num2str(frameID)]).TPhl2=TPhl2;
    assessment.(['frame' num2str(frameID)]).TPm=TPm;
    assessment.(['frame' num2str(frameID)]).FPhl2=FPhl2;
    assessment.(['frame' num2str(frameID)]).FNm=FNm;
    if isempty(globalPlanes)
        assessment.(['frame' num2str(frameID)]).Nnap=0;
    else
        assessment.(['frame' num2str(frameID)]).Nnap=globalPlanes.Nnap;
    end
    
% end
% complement assessment fields
assessment.Parameters.tao=tao;
assessment.Parameters.theta=theta;
assessment.Parameters.NpointsDiagPpal=NpointsDiagPpal;
assessment.Parameters.planeType=planeType;


% plot estimated and gt poses in qm--solve saving of pathPoints to enable
% this section
figure,
    plotEstimationsByFrame_v2(globalPlanes.values, planeType, sessionID, frameID);%script