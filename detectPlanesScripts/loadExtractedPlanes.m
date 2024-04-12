function [localPlanes, cameraPose]=loadExtractedPlanes(rootPath,scene,frameID,...
    processedScenesPath, tresholdsV, PKFlag, compensateFactor)
% This function load extracted planes per frame and its properties, classify those 
% planes comparing properties with thresholds and pack the classified data 
% into a cell of objects (localPlanes). The function also loads the camera 
% pose (qc_h) at each keyframe in the session
% 
% The properties can be divided into two groups:
% (1) primary properties. plane normal, geometric center, distance D,
% path to pointcloud, 
% (2) derived properties. type, xyTilt, ...

% 1. declares parameters and init variables
% 2. load previous knowledge of box size in form of lengthBounds
% 3. load camera poses for keyframes of the session
% 4. manages the processing of each keyframe in the session

if nargin<7
	PKFlag=true;%previous knowledge Flag
end
mode=1;% mode: (0,1), (w/out previous knowledge, with previous knowledge)
th_distance_depthCamera=[tresholdsV(6), tresholdsV(7)];
%% 1 declaring parameters 
plotFlag=0;
conditionalAssignationFlag=false;
% initiallizing variables
assignedPlanes=[];
unassignedPlanes=[];
globalPlanes={};
localPlanes={};
myBoxes=[];
groundNormal=0;
groundD=0;

%% 2. load previous knowledge of box size in form of lengthBounds
[lengthBoundsTop, lengthBoundsP] =computeLengthBounds_v2(rootPath, scene);%in mm
%% 3. load camera poses for keyframes of the session
% cameraPoses=importdata(rootPath+['corrida' num2str(scene)]+'\HL2\Depth Long Throw_rig2world.txt');
% cameraPoses=importdata(rootPath+['session' num2str(scene)]+'/raw/HL2/Depth Long Throw_rig2world.txt');
cameraPosePath=fullfile(rootPath, ['session' num2str(scene)],...
    'raw', 'HL2', 'Depth Long Throw_rig2world.txt');
cameraPoses = myCameraPosesRead(cameraPosePath);%mm
%% 4. manages the processing of each keyframe in the session
% for i=1:length(frames)
% load planes of frame i and save acceptedPlanes
%     frame=frames(i);
    cameraPose=from1DtoTform(cameraPoses(frameID,:));
%     in_planesFolderPath=[processedScenesPath '\corrida'  num2str(scene) '\frame'  num2str(frame) '\'];%extracted planes with efficientRANSAC
%     in_planesFolderPath=[processedScenesPath '/corrida'  num2str(scene) '/frame'  num2str(frame) '/'];%extracted planes with efficientRANSAC
    in_planesFolderPath=fullfile(processedScenesPath,['session' num2str(scene)],...
        ['frame' num2str(frameID)] );
    cd1=cd;
    cd(in_planesFolderPath);
    Files1=dir('*.ply');
    cd(cd1);
    numberPlanes=length(Files1);
% loads primary properties, extract ground plane properties and classify planes that belong to a single frame    
    [localPlanes, localAcceptedPlanesByFrame, ~,...
        groundNormal, groundD ] =loadExtractedPlanesByFrame(localPlanes, in_planesFolderPath,...
        numberPlanes, scene, frameID, tresholdsV, cameraPose, lengthBoundsP,...
        lengthBoundsTop, groundNormal, groundD, mode, compensateFactor);%mode: (0,1), (w/out previous knowledge, with previous knowledge)
% add properties related with fitness for acceptedPlanes () 
    if ~isempty(localAcceptedPlanesByFrame)
        mySetFitnessPlane(localPlanes,localAcceptedPlanesByFrame, th_distance_depthCamera);
    end
% end

end