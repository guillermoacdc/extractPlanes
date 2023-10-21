% script to plot estimations and ground truth planes by frame
% _v2 plot top and perpendicular planes in a single figure
clc
close all
clear

%% set parameters
sessionID=10;
frameID=11;
tao=50;
theta=0.5;
NpointsDiagPpal=30;

%% load estimations for all frames
app='_v12';
% [dataSetPath,evalPath]=computeMainPaths(sessionID, app);
dataSetPath = computeReadPaths(sessionID);
evalPath = computeReadWritePaths(app);

inputFileName=['estimatedPoses_ia_planeType' num2str(0) '.json'];
estimatedPoses0 = loadEstimationsFile(inputFileName,sessionID, evalPath);
inputFileName=['estimatedPoses_ia_planeType' num2str(1) '.json'];
estimatedPoses1 = loadEstimationsFile(inputFileName,sessionID, evalPath);

%% load estimated planes
globalPlanes=loadGlobalPlanesFromFrame(estimatedPoses0.(['frame' num2str(frameID)]),...
estimatedPoses1.(['frame' num2str(frameID)]));
%% load gt planes for the current frame
gtPlanes=loadGTPlanes(sessionID,frameID);
    
    
% plot estimated and gt poses in qm--solve saving of pathPoints to enable
% this section
syntheticPlaneType=4;%to plot all sides of the gt box
figure,
    plotEstimationsByFrame_v3(globalPlanes.values, syntheticPlaneType, sessionID, frameID);%script