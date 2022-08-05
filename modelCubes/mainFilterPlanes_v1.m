%  First version of filter planes with previous knowledge. The script
%  filter the planes based on three properties
% 1. D distance
% 2. Length L1, L2
% 3. normal of the planes
% The script also computes new properties for the planes
% 1. pose, saved in tform
% 2. type of plane
% 3. xyTilt
% 4. L1toY
clc
close all
clear

% declaring parameters 
scene=5;
th_angle=15*pi/180;%radians
th_size=150;%number of points
th_lenght=10;% 10 cm - Update with tolerance_length; is in a high value (30) to pass most of the planes
th_occlusion=1.4;%
D_Tolerance=0.1;%mt
plotFlag=0;
parameters_PK=[th_lenght, th_size, th_angle, th_occlusion, D_Tolerance];
conditionalAssignationFlag=false;
rootPath="C:\lib\boxTrackinPCs\";
% load frames vector
frames=[2:9 20:29]; 
% frames=[2:7]; 

% load length bounds
previousKnowledgeFileName=rootPath+['scene' num2str(scene)]+"\previousKnowledgeFile.txt";
% loading bound parameters for the scene
[lengthBoundsTop, lengthBoundsP] =computeLengthBounds(previousKnowledgeFileName);%in cm


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
    keyPlaneID=[5 3];
    keyPlaneTwins=trackKeyPlane(keyPlaneID,localPlanes,frames);
    storeTwinsDescriptors(keyPlaneID, keyPlaneTwins, localPlanes);

    figure,
    myPlotPlanes_v2(localPlanes, keyPlaneTwins)
    title (['Twins with plane 5-3 '])


    keyframe=20;
    figure,
    myPlotPlanes_v2(localPlanes, localPlanes.(['fr' num2str(keyframe)]).acceptedPlanes)
    title (['accepted planes at frame ' num2str(keyframe)])


    
    
    
    
    
    
    
    
    
    return

    figure,
    myPlotPlanes_v2(localPlanes, [27 15; 27 6; 5 5])
    title (['merged planes at frame ' num2str(frame)])

% frames=[2:7 20:27 40:44 53:57 60:62]; 
IDsByFrame=extractIDsFromVector(localPlanes.fr62.values);

figure,
    myPlotPlanes_v2(localPlanes, IDsByFrame)
    title (['merged planes at frame ' num2str(frame)])


% figure,
% myPlotPlanes_v2(localPlanes, [ 2 9])
% hold on
% myPlotPlanes_v2(localPlanes, [ 3 8; 4 5; 5 2])

% myPlotPlanes_v2(localPlanes, [4 4; 4 5])
% myPlotPlanes_v2(localPlanes, [5 2; 5 7; 5 12; 5 10; 5 17 ])


commonPlaneBtwnFrames =[2 9; 3 8; 4 5; 5 2; 20 6; 21 5; 22 9; 23 2;24 3;25 3;40 6; 41 7;42 8;53 7;54 8;55 5;56 2;57 2;62 1 ];
figure,
    myPlotPlanes_v2(localPlanes, commonPlaneBtwnFrames)
    title (['common plane btwn frames ' ])


L1gt=0.3;
L2gt=0.4;

L=extractL1L2FromID(localPlanes,commonPlaneBtwnFrames);
gc=extractgcFromID(localPlanes,commonPlaneBtwnFrames);


myTickLabels=convertIDsToCell(commonPlaneBtwnFrames);
figure,
    subplot(311),...
        stem(3-gc)
        xticks([1:size(gc,1)])
        xticklabels(myTickLabels)
        xtickangle(90)
        ylabel 'geometricCenter'
        grid on
        title 'properties in common planes btwn frames'
%         title 'geometric center in common planes btwn frames'
    axis tight
    subplot(312),...
        stem(0.3-L(:,1))
        xticks([1:size(gc,1)])
        xticklabels(myTickLabels)
        xtickangle(90)        
        ylabel 'L1'
        grid on
            axis tight
    subplot(313),...
        stem(0.4-L(:,2))
        xticks([1:size(gc,1)])
        xticklabels(myTickLabels)
        xtickangle(90) 
        ylabel 'L2'
        xlabel 'frames'
        grid on
            axis tight
figure,
myPlotPlanes_v2(localPlanes, [25 3; 2 9])
