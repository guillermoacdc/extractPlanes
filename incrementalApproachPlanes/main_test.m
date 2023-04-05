clc
close all
clear all

% dataSetPath="G:\Mi unidad\boxesDatabaseSample\";
% PCpath='G:\Mi unidad\semestre 9\lowOcclusionsessionIDs_processed';

sessionID=3;
planeType=0;
[dataSetPath,~,PCpath] = computeMainPaths(sessionID);
keyFrames=loadKeyFrames(dataSetPath,sessionID);
% return

th_angle=15*pi/180;%radians
th_size=150;%number of points
th_lenght=10;% 10 cm - Update with tolerance_length; is in a high value (30) to pass most of the planes
th_occlusion=1.4;%
D_Tolerance=0.1;%mt
tresholdsV=[th_lenght, th_size, th_angle, th_occlusion, D_Tolerance];

frameID=5;
localPlanes=loadExtractedPlanes(dataSetPath,sessionID,frameID,PCpath, tresholdsV);

[xzPlanes, xyPlanes, zyPlanes] =extractTypes(localPlanes,...
        localPlanes.(['fr' num2str(frameID)]).acceptedPlanes); 
    switch planeType
        case 0
            estimatedPlanesID = xzPlanes;
        case 1
            estimatedPlanesID = xyPlanes;
        case 2
            estimatedPlanesID = zyPlanes;
    end

figure,
myPlotPlanes_v2(localPlanes,estimatedPlanesID)
title (['boxes detected in sessionID/frame ' num2str(sessionID) '/' num2str(frameID)])



