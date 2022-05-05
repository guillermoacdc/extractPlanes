%  version of detection of boxes between frames
% update with 
% 1. save myPlanes in an struct with fields fr1, fr2... frN
% 2. 
clc
close all
clear

% declaring parameters 
scene=5;
frames=[2:9 20:29]; 
th_angle=15*pi/180;%radians
th_size=150;%number of points
th_lenght=10;%cm - Update with tolerance_length; is in a high value to pass most of the planes
th_occlusion=1.4;%
D_Tolerance=0.1;%mt
plotFlag=0;
parameters_PK=[th_lenght, th_size, th_angle, th_occlusion, D_Tolerance];
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

% iterative tasks
% for i=1:length(frames)
for i=1:5
%%     load planes of frame i and save acceptedPlanes
    frame=frames(i);
    in_planesFolderPath=['C:/lib/sharedData/sc' num2str(scene) '/outputPlanes/m_minSupport(50)/DT0_01/frame'  num2str(frame)  '/'];%extracted planes with efficientRANSAC
    cd1=cd;
    cd(in_planesFolderPath);
    Files1=dir('*.ply');
    cd(cd1)
    numberPlanes=length(Files1);
    
    [myPlanes acceptedPlanesByFrame rejectedPlanesByFrame groundNormal groundD ] =loadPlanes_v2(myPlanes, in_planesFolderPath, numberPlanes, scene, frame, parameters_PK, lengthBounds, groundNormal, groundD, 1);%mode: (0,1), (w/out previous knowledge, with previous knowledge)
%     globalRejectedPlanes=[globalRejectedPlanes;rejectedPlanesByFrame];
    globalAcceptedPlanes=[globalAcceptedPlanes;acceptedPlanesByFrame];
    

    
%% cuboid detection on acceptedPlanes
    [assignedPlanes unassignedPlanes]=cuboidDetectionv2_v2(myPlanes, th_angle, acceptedPlanesByFrame, frame);
    
%         requires computation of _diff to avoid duplicates
    assignedPlanes_diff=setdiff_v2(assignedPlanes, localAssignedP);
%         unassignedPlanes_diff=setdiff(unassignedPlanes, localUnassignedP);
    localAssignedP=[localAssignedP; assignedPlanes_diff];
        
%     localAssignedP=[localAssignedP; assignedPlanes];
%     localUnassignedP=[localUnassignedP; unassignedPlanes];
%     allPlanesIds=computeAllPlanesIds(myPlanes,globalRejectedPlanes);
    localUnassignedP=setdiff_v2(globalAcceptedPlanes, localAssignedP);
    assignedPlanes=[];
    unassignedPlanes=[];
    
    if(flagFirstBox)
        globalAssignedP=localAssignedP;
        globalUnassignedP=localUnassignedP;
        globalBoxes=localBoxes;
        localAssignedP=[];
        localUnassignedP=[];
        localBoxes=[];
    end

% cuboid mapping
    if (size(localAssignedP,1)>1)
%% cuboid detection for planes in local cuboid map        
        [assignedPlanes unassignedPlanes]=cuboidDetectionv2_v2(myPlanes, th_angle, localAssignedP, frame);
%         requires computation of _diff to avoid duplicates
        assignedPlanes_diff=setdiff_v2(assignedPlanes, localAssignedP);
%         unassignedPlanes_diff=setdiff(unassignedPlanes, localUnassignedP);
        localAssignedP=[localAssignedP; assignedPlanes_diff];
%         localUnassignedP=[localUnassignedP unassignedPlanes_diff];
        localUnassignedP=setdiff_v2(globalAcceptedPlanes, localAssignedP);
        assignedPlanes=[];
        unassignedPlanes=[];
    end

    if(~isempty(localAssignedP))%localAssignedP is not empty
%% cuboid Detection for (local unassigned, local assigned)        
        [assignedPlanes unassignedPlanes]=cuboidDetectionv2_v2(myPlanes, th_angle, localUnassignedP, frame, localAssignedP);
%         requires computation of _diff to avoid duplicates
        assignedPlanes_diff=setdiff_v2(assignedPlanes, localAssignedP);
%         unassignedPlanes_diff=setdiff(unassignedPlanes, localUnassignedP);
        localAssignedP=[localAssignedP; assignedPlanes_diff];
%         localUnassignedP=[localUnassignedP unassignedPlanes_diff];
        
        localUnassignedP=setdiff_v2(globalAcceptedPlanes, localAssignedP);
        assignedPlanes=[];
        unassignedPlanes=[];
%% naivy cuboid detection for local unassigned planes
        [assignedPlanes unassignedPlanes]=cuboidDetectionv2_v2(myPlanes, th_angle, localUnassignedP, frame);
%         requires computation of _diff to avoid duplicates
        assignedPlanes_diff=setdiff_v2(assignedPlanes, localAssignedP);
        localAssignedP=[localAssignedP; assignedPlanes_diff];
        localUnassignedP=setdiff_v2(globalAcceptedPlanes, localAssignedP);
        assignedPlanes=[];
        unassignedPlanes=[];
%%         create boxes

        [localBoxes flagFirstBox]=createBoxes_v2(myPlanes, localAssignedP, localBoxes);
    end

% figures,
    figure,
    myPlotPlanes_v2(myPlanes, acceptedPlanesByFrame, inputFramesPath)
    title (['planes in frame ' num2str(frame)])
    if size(localBoxes,1)>0
        figure,
        myPlotBoxes(myPlanes, localBoxes)
        title (['Detected boxes in iteration ' num2str(i)])
    end

end
