clc
close all
clear all


sessionID=3;
[dataSetPath,~,PCpath] = computeMainPaths(sessionID);
frame=5;
th_angle=15*pi/180;%radians
th_size=150;%number of points
th_lenght=10*10;%mm 10 cm - Update with tolerance_length; is in a high value (30) to pass most of the planes
th_occlusion=1.4;%
D_Tolerance=0.1*1000;%mm    0.1 m
tresholdsV=[th_lenght, th_size, th_angle, th_occlusion, D_Tolerance];

localPlanes=loadExtractedPlanes(dataSetPath,sessionID,frame,PCpath, tresholdsV);


figure,
myPlotPlanes_v2(localPlanes,localPlanes.(['fr' num2str(frame)]).acceptedPlanes)
title (['boxes detected in sessionID/frame ' num2str(sessionID) '/' num2str(frame)])
return

myAcceptedPlanes=ones(17,2);
myAcceptedPlanes(:,1)=frame;
myAcceptedPlanes(:,2)=2:18;
figure,
myPlotPlanes_v2(localPlanes,myAcceptedPlanes)
title (['boxes detected in sessionID/frame ' num2str(sessionID) '/' num2str(frame)])



