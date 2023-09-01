clc
close all
clear


sessionID=3;
[~,savePath]=computeMainPaths(sessionID);
[frames, planeID, boxID] = getTargetFramesFromScene(sessionID);
frameID=frames(1);
fileName='referencePose.json';
% 1. Plane filtering parameters
th_angle=15*pi/180;%radians
th_size=150;%number of points
th_lenght=10*10;%mm 10 cm - Update with tolerance_length; is in a high value (30) to pass most of the planes
th_occlusion=1.4;%
D_Tolerance=0.1*1000;%mm ... 0.1 m
planeFilteringParameters=[th_lenght, th_size, th_angle, th_occlusion, D_Tolerance];

refPlaneDescriptor = computeReferencePoseBySession(sessionID,...
    frameID, planeID, planeFilteringParameters);
refPlaneDescriptor_struct=convertObjectToStruct(refPlaneDescriptor, boxID);
mySaveStruct2JSONFile(refPlaneDescriptor_struct,fileName,savePath,sessionID)