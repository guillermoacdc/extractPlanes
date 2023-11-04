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
sessionID=10;
[dataSetPath, PCpath]=computeReadPaths(sessionID);
app='_v12';
evalPath=computeReadWritePaths(app);
keyFrames=loadKeyFrames(dataSetPath,sessionID);

frames=keyFrames(2:6); 
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
% [dataSetPath,evalPath,PCpath]=computeMainPaths(sessionID);

% PCpath=['C:/lib/sharedData/sc' num2str(sessionID) '/inputFrames/'];

% loading bound parameters for the sessionID
% lengthBounds=loadBoundParameters(sessionID);
[lengthBoundsTop, lengthBoundsP]=computeLengthBounds_v2(dataSetPath,sessionID)

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
cameraPosePath=fullfile(dataSetPath, ['session' num2str(sessionID)],...
    'raw', 'HL2', 'Depth Long Throw_rig2world.txt');
cameraPoses = myCameraPosesRead(cameraPosePath);%mm

% tic
%% load global planes from json file 
    inputFileName=['estimatedPoses_ia_planeType' num2str(0) '.json'];
    estimatedPoses0 = loadEstimationsFile(inputFileName,sessionID, evalPath);
    inputFileName=['estimatedPoses_ia_planeType' num2str(1) '.json'];
    estimatedPoses1 = loadEstimationsFile(inputFileName,sessionID, evalPath);

for i=5:length(frames)

%%     load planes of frame i and save acceptedPlanes
    frameID=frames(i);
    myPlanes.(['fr' num2str(frameID)]).cameraPose=from1DtoTform(cameraPoses(frameID,:));
    myPlanes.(['fr' num2str(frameID)]).values=loadGlobalPlanesFromFrame(estimatedPoses0.(['frame' num2str(frameID)]),...
        estimatedPoses1.(['frame' num2str(frameID)]));
    myPlanes.(['fr' num2str(frameID)]).acceptedPlanes=extractIDsFromVector(myPlanes.(['fr' num2str(frameID)]).values);
    
    

%% end
    
    %% 3. naivy cuboid detection for local unassigned planes    
    % add acceptedPlanesByFrame to the list localUnassignedP
    localUnassignedP=[localUnassignedP; myPlanes.(['fr' num2str(frameID)]).acceptedPlanes];
    % apply a naivy cuboid detection for localUnassignedP
    
    [localAssignedP, localUnassignedP]=cuboidDetectionAndUPdate(myPlanes, ...
        th_angle, localUnassignedP,conditionalAssignationFlag,...
        globalAcceptedPlanes);


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