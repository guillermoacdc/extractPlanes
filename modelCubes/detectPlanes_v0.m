function localPlanes=detectPlanes(rootPath,scene,frames)

% declaring parameters 
% scene=5;
th_angle=15*pi/180;%radians
th_size=150;%number of points
th_lenght=10;% 10 cm - Update with tolerance_length; is in a high value (30) to pass most of the planes
th_occlusion=1.4;%
D_Tolerance=0.1;%mt
plotFlag=0;
parameters_PK=[th_lenght, th_size, th_angle, th_occlusion, D_Tolerance];
conditionalAssignationFlag=false;

% load length bounds
previousKnowledgeFileName=rootPath+['scene' num2str(scene)]+"\previousKnowledgeFile.txt";
% loading bound parameters for the scene
% [lengthBoundsTop, lengthBoundsP] =computeLengthBounds(previousKnowledgeFileName);%in cm
[lengthBoundsTop, lengthBoundsP] =computeLengthBounds_v2(rootPath, scene);%in cm

% initiallizing variables
assignedPlanes=[];
unassignedPlanes=[];
globalPlanes={};
localPlanes={};
myBoxes=[];
groundNormal=0;
groundD=0;
cameraPoses=importdata(rootPath+['scene' num2str(scene)]+'\Depth Long Throw_rig2world.txt');

for i=1:length(frames)

%%     load planes of frame i and save acceptedPlanes
    frame=frames(i);
    cameraPose=from1DtoTform(cameraPoses(frame,:));
    in_planesFolderPath=[rootPath + 'scene' +  num2str(scene) + '\detectedPlanes\frame'  + num2str(frame) + '\'];%extracted planes with efficientRANSAC
    cd1=cd;
    cd(in_planesFolderPath);
    Files1=dir('*.ply');
    cd(cd1)
    numberPlanes=length(Files1);
    
    [localPlanes, localAcceptedPlanesByFrame, rejectedPlanesByFrame,...
        groundNormal, groundD ] =loadPlanes_v4(localPlanes, in_planesFolderPath,...
        numberPlanes, scene, frame, parameters_PK, cameraPose, lengthBoundsP,...
        lengthBoundsTop, groundNormal, groundD, 1);%mode: (0,1), (w/out previous knowledge, with previous knowledge)

end

end