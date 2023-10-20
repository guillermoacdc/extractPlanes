% computes the estimation and assesment of pose estimation for a set of
% sessions with a single approach

clc
close all
clear

% low occlussion scenes
% sessionsID=[ 		53	54];% 
% 3
sessionsID=[ 10	12	13	17	19	20	25 27	32	33	35 36 39 45	52	53	54];% 
% sessionsID=[ 27	32	33	35 36 39 45	52	53	54];% 
% sessionsID=10;% 
app='v_12';
Ns=size(sessionsID,2);
%% setting parameters
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
theta=0.5;
asessmentPoseParameters=[NpointsDiagPpal tao_v];
% 3. Parameteres used in the stage Merging planes between frames
% - used in the function computeTypeOfTwin
tao_merg=50;% mm
theta_merg=0.5;%in percentage
th_IoU=0.2;% percent
th_coplanarDistance=20;%mm
gridStep=1;
mergingPlaneParameters=[tao_merg theta_merg th_IoU th_coplanarDistance gridStep];
% 4. Parameters used in temporal filtering stage
radii=15;%mm - initial value. The raddi changes every time a box is extracted from consolidation zone
windowSize=10;%frames
th_detections=0.3;%percent - not used in version 1 - update with th_vigency
tempFilteringParameters=[radii windowSize th_detections];
% 5. Parameteres used to set the type of planes to process: perpendicular or
% parallel to ground. 
planeTypes=[0 1];%{0 for parallel to ground, 1 for perpendicular to ground}
% planeTypes=[ 1];
Npt=size(planeTypes,2);
%6. Parameters to merge pointclouds - used in the approach 2
planeModelParameters(1) =   12;% maxDistance in mm
% 7. compensate factor for perpendicular planes supported on the floor
compensateFactor=0;%mm--- no funcionó como se esperaba. Valor probado: 


for i=1:Ns
    sessionID=sessionsID(i);
    for j=1:Npt
        planeType=planeTypes(j);
        fileName1=['estimatedPoses_ia_planeType' num2str(planeType) '.json'];
%         fileName1=['estimatedPoses_ia_planeType' num2str(planeType) '_v2f.json'];

        myPlaneTracker(sessionID, fileName1, planeFilteringParameters, ...
            mergingPlaneParameters, tempFilteringParameters, ...
            planeType, planeModelParameters, compensateFactor, app);
%             estimatePoses_ia1_v2(sessionID, fileName1, planeFilteringParameters, ...
%             asessmentPoseParameters, mergingPlaneParameters, tempFilteringParameters, ...
%             planeType);
    end
end


% removing warnings
w = warning('query','last');
id=w.identifier;
warning('off',id)