% first version of detection of boxes between frames
clc
close all
clear

% declaring parameters 
scene=5;
frames=[2:9]; 
th_angle=15*pi/180;%radians
th_size=150;%number of points
th_lenght=30;%cm - Update with tolerance_length; is in a high value to pass most of the planes
th_occlusion=1.4;%
D_Tolerance=0.1;%mt
plotFlag=0;
parameters_PK=[th_lenght, th_size, th_angle, th_occlusion, D_Tolerance];
% declaring paths to read data
inputFramesPath=['C:/lib/sharedData/sc' num2str(scene) '/inputFrames/'];

% initiallizing variables
assignedPlanes=[];
unassignedPlanes=[];
myPlanes=[];
myBoxes=[];
groundNormal=0;
groundD=0;
% loading bound parameters for the scene
    parameters=load(['scene' num2str(scene) 'Planes.txt']);%IDplane, IdBox, L1(cm), L2(cm), normalType
    features=parameters(:,[3:5]);
    L1max=max(features(:,1));
    L2max=max(features(:,2));
    L1min=min(features(:,1));
    L2min=min(features(:,2));
    lengthBounds=[L1min L1max L2min L2max];

% iterative tasks
for i=1:length(frames)
%%     load planes of frame i and save acceptedPlanes
    frame=frames(i);
    in_planesFolderPath=['C:/lib/sharedData/sc' num2str(scene) '/outputPlanes/m_minSupport(50)/DT0_01/frame'  num2str(frame)  '/'];%extracted planes with efficientRANSAC
    cd1=cd;
    cd(in_planesFolderPath);
    Files1=dir('*.ply');
    cd(cd1)
    numberPlanes=length(Files1);
    [myPlanes acceptedPlanes groundNormal groundD] =loadPlanes(myPlanes, in_planesFolderPath, numberPlanes, scene, frame, parameters_PK, lengthBounds, groundNormal, groundD, 1);%mode: (0,1), (w/out previous knowledge, with previous knowledge)
    
    [frame acceptedPlanes]
    
%%     update assigned and unassigned planes 
    [assignedPlanes unassignedPlanes] = updateAssignedPlanes(myPlanes);

%%     update assigned planes by applying "cuboid detection" strategy btwn  unassinged and assigned planes
    cuboidDetection(myPlanes, th_angle, unassignedPlanes, assignedPlanes);
    [assignedPlanes unassignedPlanes] = updateAssignedPlanes(myPlanes);

%     update cuboid shapeParameters

%     compute new_unassigned planes by applying "modelling cubes" btwn
%     unassigned planes
    cuboidDetection(myPlanes, th_angle, unassignedPlanes);
    [assignedPlanes unassignedPlanes] = updateAssignedPlanes(myPlanes);
%     figure,
%     myPlotPlanes(myPlanes, [unassignedPlanes assignedPlanes], inputFramesPath);

%     update cuboid shapeParameters
    myBoxes=boxFeaturesEstimation(myBoxes,assignedPlanes,myPlanes);

% end iterative tasks
end
