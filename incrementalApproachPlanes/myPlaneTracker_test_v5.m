% computes the estimation of box' pose for a set of
% sessions with a single approach

clc
close all
clear

% low occlussion scenes
% sessionsID=[ 3 10	12	13	17	19	20	25 27	32	33	35 36 39 45	52	53	54];% 
sessionsID=10;% 
app='_vdebug';%appendix of the folder where results are saved
Ns=size(sessionsID,2);
%% setting parameters
% 1. Plane filtering parameters
th_angle=18*pi/180;%radians---en planos se uso 15 en cajas se usa 18
th_size=150;%number of points
th_lenght=10*10;%mm 10 cm - Update with tolerance_length; is in a high value (30) to pass most of the planes
th_occlusion=1.4;%
D_Tolerance=0.1*1000;%mm ... 0.1 m
thd_max_depthCamera=5460;%source: https://learn.microsoft.com/en-us/azure/kinect-dk/hardware-specification
thd_min_depthCamera=1500;%
planeFilteringParameters=[th_lenght, th_size, th_angle, th_occlusion,...
    D_Tolerance, thd_min_depthCamera, thd_max_depthCamera];

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
%6. Parameters to merge pointclouds - used in the approach 2
planeModelParameters(1) =   12;% maxDistance in mm
% 7. compensate factor for perpendicular planes supported on the floor
compensateFactor=0;%mm--- no funcionó como se esperaba. Valor probado: 
evalPath=computeReadWritePaths(app);

for i=1:Ns
    sessionID=sessionsID(i);
%     fileNameBoxes='estimatedBoxes.json';
    fileNameGlobal='globalEstimations.json';
    fileNameLocal='localEstimations.json';
    [globalEstimations_plane, localEstimations_plane]=myPlaneTracker_v5(sessionID, ...
         planeFilteringParameters, ...
            mergingPlaneParameters, tempFilteringParameters, ...
            planeModelParameters, compensateFactor);
    % write json file to disk
    mySaveStruct2JSONFile(globalEstimations_plane,fileNameGlobal,evalPath,sessionID);
    mySaveStruct2JSONFile(localEstimations_plane,fileNameLocal,evalPath,sessionID);

end



% removing warnings
w = warning('query','last');
id=w.identifier;
warning('off',id)