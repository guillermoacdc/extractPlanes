%  version of detection of boxes between frames
% update with 
% 1. save myPlanes in an struct with fields fr1, fr2... frN
% 2. Add to each field two subfields: (1) camera pose, (2) values. The
% camera poses were loaded from the file Depth Long Throw rig2world. The
% values field contain a vector of plane objects, with all the planes
% detected in that frame
% 3. Reformulate the cuboidDetection algorithms to avoid innecesary
% searches: use search based on properties type and PlaneTilt
clc
close all
clear

% declaring parameters 
scene=5;
% frames=[2:6]; 
frames=[2:5 53:55]; 
th_angle=15*pi/180;%radians
th_size=150;%number of points
th_lenght=300;%mm 30 cm - Update with tolerance_length; is in a high value (30) to pass most of the planes
th_occlusion=1.4;% 
th_IOU_min=0.3; %percentage
th_IOU_max=0.7; %percentage
th_dlower=1.5*1000;%mm
th_dupper=2.5*1000;%mm
th_gc=0.2*1000;%mm
th_merge=[th_gc, th_angle, th_IOU_min, th_IOU_max, th_dlower, th_dupper];

D_Tolerance=0.1*1000;%mm
plotFlag=0;
parameters_PK=[th_lenght, th_size, th_angle, th_occlusion, D_Tolerance];
conditionalAssignationFlag=false;
% declaring paths to read data. path to point clouds
[dataSetPath,evalPath,PCpath]=computeMainPaths(scene);
% PCpath=['C:/lib/sharedData/sc' num2str(scene) '/inputFrames/'];

% loading bound parameters for the scene
% lengthBounds=loadBoundParameters(scene);
[lengthBoundsTop, lengthBoundsP]=computeLengthBounds_v2(dataSetPath,scene);

% initiallizing variables
assignedPlanes=[];
unassignedPlanes=[];
myPlanes={};
myPlanes.fr0.values=[];
myJoinedPlanes={};
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

% cameraPoses=importdata('Depth Long Throw_rig2world.txt');
cameraPosePath=fullfile(dataSetPath, ['session' num2str(scene)],...
    'raw', 'HL2', 'Depth Long Throw_rig2world.txt');
cameraPoses = myCameraPosesRead(cameraPosePath);%mm

% tic
% iterative tasks
for i=1:length(frames)

%%     load planes of frame i and save acceptedPlanes
    frame=frames(i);
    cameraPose=from1DtoTform(cameraPoses(frame,:));
%     in_planesFolderPath: path to point clouds of session scene and frame
%     frameID
% 
%     in_planesFolderPath=['C:/lib/sharedData/sc' num2str(scene) '/outputPlanes/m_minSupport(50)/DT0_01/frame'  num2str(frame)  '/'];%extracted planes with efficientRANSAC
    in_planesFolderPath=fullfile(PCpath,['corrida' num2str(scene)], ['frame' num2str(frame)]);
    cd1=cd;
    cd(in_planesFolderPath);
    Files1=dir('*.ply');
    cd(cd1)
    numberPlanes=length(Files1);
% loads primary properties, extract ground plane properties and classify planes that belong to a single frame        
    [myPlanes, acceptedPlanesByFrame, rejectedPlanesByFrame,...
        groundNormal, groundD ] =loadExtractedPlanesByFrame(myPlanes, in_planesFolderPath,...
        numberPlanes, scene, frame, parameters_PK, cameraPose, lengthBoundsP, lengthBoundsTop,...
        groundNormal, groundD, 1);%mode: (0,1), (w/out previous knowledge, with previous knowledge)


%     figure,
%     myPlotPlanes_v2(myPlanes, acceptedPlanesByFrame, PCpath)
%     myPlotCameraPose(myPlanes.(['fr' num2str(frame)]).cameraPose,frame)
%     title (['planes in frame ' num2str(frame)])

%% convert twin planes into joined planes. Save in field fr0 of myPlanes
    myPlanes=manageTwinPlanes(myPlanes,...
        acceptedPlanesByFrame, th_merge);
    

%%     marca de implementación!!!
    globalAcceptedPlanes=[globalAcceptedPlanes;myPlanes.fr0.acceptedPlanes];

    %% 3. naivy cuboid detection for local unassigned planes    
    % add acceptedPlanesByFrame to the list localUnassignedP
    localUnassignedP=[localUnassignedP; myPlanes.fr0.acceptedPlanes];
    % apply a naivy cuboid detection for localUnassignedP
    
%     [localAssignedP localUnassignedP]=cuboidDetectionAndUPdate(myJoinedPlanes, ...
%         th_angle, localUnassignedP,conditionalAssignationFlag,...
%         globalAcceptedPlanes);


    %% cuboid mapping
    % 1. cuboid detection for planes in local cuboid map 
    if (size(localAssignedP,1)>1)

        [localAssignedP localUnassignedP]=cuboidDetectionAndUPdate(myPlanes, ...
        th_angle, localAssignedP,conditionalAssignationFlag,...
        globalAcceptedPlanes);
        assignedPlanes=[];
        unassignedPlanes=[];
    end
    % 2. cuboid Detection for (local unassigned, local assigned)        
    if(~isempty(localAssignedP))%localAssignedP is not empty
%         localAssignedP=cuboidDetectionv2_v4(conditionalAssignationFlag, ...
%             myPlanes, th_angle, localUnassignedP, localAssignedP);
%         cuboidDetection_pair_v7(myPlanes, th_angle, localUnassignedP,...
%             localAssignedP, conditionalAssignationFlag);
%         localAssignedP=updateAssignedPlanes_v4(myPlanes);
%         localUnassignedP=setdiff_v2(globalAcceptedPlanes, localAssignedP);
        cuboidDetectionAndUPdate_pair(myPlanes, th_angle, localUnassignedP,...
            localAssignedP, conditionalAssignationFlag, globalAcceptedPlanes);
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
% toc
extractBoxIds(localBoxes)