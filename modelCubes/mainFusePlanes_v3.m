%  version of fuse planes between frames
clc
close all
clear

% declaring parameters 
scene=5;
frames=[2:7 20:27 40:44 53:57]; 
% frames=[2:6 54:55]; 
th_angle=15*pi/180;%radians
th_size=150;%number of points
th_lenght=30;% 10 cm - Update with tolerance_length; is in a high value (30) to pass most of the planes
th_occlusion=1.4;%
D_Tolerance=0.1;%mt
plotFlag=0;
parameters_PK=[th_lenght, th_size, th_angle, th_occlusion, D_Tolerance];
conditionalAssignationFlag=false;

% loading bound parameters for the scene
lengthBounds=loadBoundParameters(scene);

% initiallizing variables
assignedPlanes=[];
unassignedPlanes=[];
globalPlanes={};
localPlanes={};
myBoxes=[];
groundNormal=0;
groundD=0;
flagFirstBox=0;

localAssignedP=[];
localUnassignedP=[];
localBoxes={};
globalAssignedP=[];
globalUnassignedP=[];
globalBoxes=[];
% globalRejectedPlanes=[];
globalAcceptedPlanes=[];

cameraPoses=importdata('Depth Long Throw_rig2world.txt');

%% load global planes
    framebase=frames(1);
    cameraPose=from1DtoTform(cameraPoses(framebase,:));
    in_planesFolderPath=['C:/lib/sharedData/sc' num2str(scene) '/outputPlanes/m_minSupport(50)/DT0_01/frame'  num2str(framebase)  '/'];%extracted planes with efficientRANSAC
    cd1=cd;
    cd(in_planesFolderPath);
    Files1=dir('*.ply');
    cd(cd1)
    numberPlanes=length(Files1);
    
    [globalPlanes, globalAcceptedPlanes, rejectedPlanesByFrame,...
        groundNormal, groundD ] =loadPlanes_v3(globalPlanes, in_planesFolderPath,...
        numberPlanes, scene, framebase, parameters_PK, cameraPose, lengthBounds,...
        groundNormal, groundD, 1);%mode: (0,1), (w/out previous knowledge, with previous knowledge)

%     globalPlanesV=loadPlanesFromIDs(globalPlanes,globalAcceptedPlanes);
%     globalPlanes.(['fr' num2str(framebase)]).values=globalPlanesV;
    
% iterative tasks

for i=1:length(frames)

%%     load planes of frame i and save acceptedPlanes
    frame=frames(i);
    cameraPose=from1DtoTform(cameraPoses(frame,:));
    in_planesFolderPath=['C:/lib/sharedData/sc' num2str(scene) '/outputPlanes/m_minSupport(50)/DT0_01/frame'  num2str(frame)  '/'];%extracted planes with efficientRANSAC
    cd1=cd;
    cd(in_planesFolderPath);
    Files1=dir('*.ply');
    cd(cd1)
    numberPlanes=length(Files1);
    
    [localPlanes, localAcceptedPlanesByFrame, rejectedPlanesByFrame,...
        groundNormal, groundD ] =loadPlanes_v3(localPlanes, in_planesFolderPath,...
        numberPlanes, scene, frame, parameters_PK, cameraPose, lengthBounds,...
        groundNormal, groundD, 1);%mode: (0,1), (w/out previous knowledge, with previous knowledge)


%% merge planes
%     load planes as vectors
    
    localPlanesV=loadPlanesFromIDs(localPlanes, localAcceptedPlanesByFrame);
    globalPlanesV=loadPlanesFromIDs(localPlanes, globalAcceptedPlanes);
    
    
    dc_l=computeDistanceToCamera(localPlanes,localAcceptedPlanesByFrame);
    dc_g=computeDistanceToCamera(localPlanes,globalAcceptedPlanes);
%     merge
%     globalPlanesV = mergeIntoGlobalPlanes(localPlanesV,globalPlanesV, dc_l, dc_g);
    globalAcceptedPlanes=mergeByType(localPlanes,localAcceptedPlanesByFrame, globalAcceptedPlanes);
%     globalPlanes.(['fr' num2str(framebase)]).values=globalPlanesV;
%     globalAcceptedPlanes=extractIDsFromVector(globalPlanesV);


    
end

    figure,
    myPlotPlanes_v2(localPlanes, globalAcceptedPlanes)
    title (['merged planes at frame ' num2str(frame)])




% figure,
% myPlotPlanes_v2(localPlanes, [ 2 9])
% hold on
% myPlotPlanes_v2(localPlanes, [ 3 8; 4 5; 5 2])

% myPlotPlanes_v2(localPlanes, [4 4; 4 5])
% myPlotPlanes_v2(localPlanes, [5 2; 5 7; 5 12; 5 10; 5 17 ])

