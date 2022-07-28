%  version of detection of boxes between frames
% update with 
% 1. save myPlanes in an struct with fields fr1, fr2... frN
% 2. Add to each field two subfields: (1) camera pose, (2) values. The
% camera poses were loaded from the file Depth Long Throw rig2world. The
% values field contain a vector of plane objects, with all the planes
% detected in that frame
clc
close all
clear

% declaring parameters 
scene=5;
frames=[2:9]; 
% frames=[2:5 53:55]; 
th_angle=15*pi/180;%radians
th_size=150;%number of points
th_lenght=30;% 10 cm - Update with tolerance_length; is in a high value (30) to pass most of the planes
th_occlusion=1.4;%
D_Tolerance=0.1;%mt
plotFlag=0;
parameters_PK=[th_lenght, th_size, th_angle, th_occlusion, D_Tolerance];
conditionalAssignationFlag=false;
% declaring paths to read data
inputFramesPath=['C:/lib/sharedData/sc' num2str(scene) '/inputFrames/'];

% loading bound parameters for the scene
lengthBounds=loadBoundParameters(scene);

% initiallizing variables
assignedPlanes=[];
unassignedPlanes=[];
myPlanes={};
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

tic
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
    
    [myPlanes, acceptedPlanesByFrame, rejectedPlanesByFrame,...
        groundNormal, groundD ] =loadPlanes_v3(myPlanes, in_planesFolderPath,...
        numberPlanes, scene, frame, parameters_PK, cameraPose, lengthBounds,...
        groundNormal, groundD, 1);%mode: (0,1), (w/out previous knowledge, with previous knowledge)

    figure,
    myPlotPlanes_v2(myPlanes, acceptedPlanesByFrame, inputFramesPath)
    myPlotCameraPose(myPlanes.(['fr' num2str(frame)]).cameraPose,frame)
    title (['planes in frame ' num2str(frame)])

    globalAcceptedPlanes=[globalAcceptedPlanes;acceptedPlanesByFrame];

    %% 3. naivy cuboid detection for local unassigned planes    
    % add acceptedPlanesByFrame to the list localUnassignedP
    localUnassignedP=[localUnassignedP; acceptedPlanesByFrame];
    % apply a naivy cuboid detection for localUnassignedP
    
%     localAssignedP=cuboidDetectionv2_v4(conditionalAssignationFlag, ...
%                 myPlanes, th_angle, localUnassignedP);
    cuboidDetection_naivy_v5(myPlanes, th_angle, localUnassignedP, conditionalAssignationFlag);
    localAssignedP=updateAssignedPlanes_v4(myPlanes);
    localUnassignedP=setdiff_v2(globalAcceptedPlanes, localAssignedP);


    %% cuboid mapping
    % 1. cuboid detection for planes in local cuboid map 
    if (size(localAssignedP,1)>1)
%         localAssignedP=cuboidDetectionv2_v4(conditionalAssignationFlag, ...
%             myPlanes, th_angle,localAssignedP);
        cuboidDetection_naivy_v5(myPlanes, th_angle, localAssignedP, conditionalAssignationFlag);
        localAssignedP=updateAssignedPlanes_v4(myPlanes);
        localUnassignedP=setdiff_v2(globalAcceptedPlanes, localAssignedP);
        assignedPlanes=[];
        unassignedPlanes=[];
    end
    % 2. cuboid Detection for (local unassigned, local assigned)        
    if(~isempty(localAssignedP))%localAssignedP is not empty
%         localAssignedP=cuboidDetectionv2_v4(conditionalAssignationFlag, ...
%             myPlanes, th_angle, localUnassignedP, localAssignedP);
        cuboidDetection_pair_v6(myPlanes, th_angle, localUnassignedP, localAssignedP, conditionalAssignationFlag);
        localAssignedP=updateAssignedPlanes_v4(myPlanes);
        localUnassignedP=setdiff_v2(globalAcceptedPlanes, localAssignedP);
        assignedPlanes=[];
        unassignedPlanes=[];
    % 4. create boxes
        [localBoxes flagFirstBox]=createBoxes_v4(myPlanes, localAssignedP, localBoxes);
    end

% figures,

    if size(localBoxes,1)>0
        figure,
        myPlotBoxes(myPlanes, localBoxes)
        title (['Detected boxes in iteration ' num2str(i)])
    end

end
toc
extractBoxIds(localBoxes)