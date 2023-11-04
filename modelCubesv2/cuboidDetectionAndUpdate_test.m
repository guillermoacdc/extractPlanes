clc
close all 
clear

%% set parameters
sessionID=10;
frameID=11;
app='_v12';
conditionalAssignationFlag=0;

th_angle=18*pi/180;%radians
dataSetPath = computeReadPaths(sessionID);
evalPath = computeReadWritePaths(app);

inputFileName=['estimatedPoses_ia_planeType' num2str(0) '.json'];
estimatedPoses0 = loadEstimationsFile(inputFileName,sessionID, evalPath);
inputFileName=['estimatedPoses_ia_planeType' num2str(1) '.json'];
estimatedPoses1 = loadEstimationsFile(inputFileName,sessionID, evalPath);


%% load global Planes
globalPlanes=loadGlobalPlanesFromFrame(estimatedPoses0,estimatedPoses1,frameID);


[localAssignedP, localUnassignedP]=cuboidDetectionAndUPdate(globalPlanes, ...
        th_angle, conditionalAssignationFlag);
