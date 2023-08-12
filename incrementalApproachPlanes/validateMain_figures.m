clc
close all
clear 
sessionID=39;
planeType=0;
% 1. Plane filtering parameters
th_angle=15*pi/180;%radians
th_size=150;%number of points
th_lenght=10*10;%mm 10 cm - Update with tolerance_length; is in a high value (30) to pass most of the planes
th_occlusion=1.4;%
D_Tolerance=0.1*1000;%mm ... 0.1 m
planeFilteringParameters=[th_lenght, th_size, th_angle, th_occlusion, D_Tolerance];
% 2. Parameters used in the stage Assesment Pose 
NpointsDiagPpal=20;
tao_v=50;%mm
asessmentPoseParameters=[NpointsDiagPpal tao_v];
% 3. Parameteres used in the stage Merging planes between frames
% - used in the function computeTypeOfTwin
tao_merg=50;% mm
theta_merg=0.5;%in percentage
th_IoU=0.2;% percent
th_coplanarDistance=20;%mm
mergingPlaneParameters=[tao_merg theta_merg th_IoU th_coplanarDistance];
% 4. Parameters used in temporal filtering stage
radii=15;%mm - initial value. The raddi changes every time a box is extracted from consolidation zone
windowSize=5;%frames
th_detections=0.3;%percent - not used in version 1
tempFilteringParameters=[radii windowSize th_detections];

fileName1=['estimatedPoses_ia1_planeType' num2str(planeType) '.json'];
estimatePoses_ia1(sessionID, fileName1, planeFilteringParameters, ...
                asessmentPoseParameters, mergingPlaneParameters, tempFilteringParameters, ...
                planeType);