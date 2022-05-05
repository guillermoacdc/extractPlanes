clc
close all
clear 

scene=5;
frame=2;
% scene=15;
% frame=22;%

%% define paths to load data and tresholds
inputFramesPath=['C:/lib/sharedData/sc' num2str(scene) '/inputFrames/'];

% in_planesFolderPath=['C:/lib/scene5/outputPlanes_t10/frame ('  num2str(frame)  ')/'];%extracted planes with efficientRANSAC
% in_planesFolderPath=['C:/lib/sharedData/sc' num2str(scene) '/outputPlanes/m_minSupport(50)/DT0_1/frame'  num2str(frame)  '/'];%extracted planes with efficientRANSAC
in_planesFolderPath=['C:/lib/sharedData/sc' num2str(scene) '/outputPlanes/m_minSupport(50)/DT0_01/frame'  num2str(frame)  '/'];%extracted planes with efficientRANSAC
cd1=cd;
cd(in_planesFolderPath);
Files1=dir('*.ply');
cd(cd1)
numberPlanes=length(Files1);

th_angle=15*pi/180;%radians
th_size=150;%number of points
th_lenght=30;%cm - Update with tolerance_length; is in a high value to pass most of the planes
th_occlusion=1.4;%
D_Tolerance=0.1;%mt
plotFlag=0;
%% iterative process to load plane descriptors from eRANSAC
for i=1:numberPlanes
% for i=[1 6 7]
    planeID=i;
    inliersPath=[in_planesFolderPath + "Plane" + num2str(i-1) + "A.ply"];
    [modelParameters pc]=loadPlaneParameters(in_planesFolderPath, frame,...
        planeID);
%     create the plane object
    myPlanes{i}=plane(scene, frame, planeID, modelParameters,...
        inliersPath, pc.Count);%scene,frame,pID,pnormal,Nmbinliers
    if(planeID==1)%ground plane
        groundNormal=myPlanes{i}.unitNormal;%warning: could be set as antiparallel
        groundD=abs(myPlanes{i}.D);
    end
end


%% include previous knowledge to classify planes
parameters=load(['scene' num2str(scene) 'Planes.txt']);%IDplane, IdBox, L1(cm), L2(cm), normalType
features=parameters(:,[3:5]);
L1max=max(features(:,1));
L2max=max(features(:,2));
L1min=min(features(:,1));
L2min=min(features(:,2));
lengthBounds=[L1min L1max L2min L2max];

for i=1:numberPlanes
    includePreviousKnowledge_Plane(myPlanes{i}, th_lenght, th_size, ...
        th_angle, th_occlusion, D_Tolerance, groundNormal, groundD, lengthBounds, plotFlag);
end


%% descriptive statistics
[acceptedPlanes, discardedByNormal, discardedByLength topOccludePlanes]=computeDescriptiveStatisticsOnPlanes(myPlanes);
% percentage of accepted planes
pap=length(acceptedPlanes)*100/numberPlanes;
% percentage of planes filtered by normal vector
ppfbn=length(discardedByNormal)*100/numberPlanes;
% percentage of planes filtered by length
ppfbl=length(discardedByLength)*100/numberPlanes;

%% plotPlanes
% accepted planes
figure,
myPlotPlanes(myPlanes, [1 acceptedPlanes], inputFramesPath);
hold on
title (['accepted planes (' num2str(pap) '%)'])


% figure,
% myPlotPlanesv2(myPlanes, [6 9 11 20 21 25], inputFramesPath);
% hold on

% % planes filtered by normal vector
% figure,
% myPlotPlanes(myPlanes, discardedByNormal, inputFramesPath);
% title (['planes filtered by its normal vector or D distance value (' num2str(ppfbn) '%)'])
% 
% % top occluded planes
% figure,
% myPlotPlanes(myPlanes, topOccludePlanes, inputFramesPath);
% hold on
% title (['top Occluded planes '])

% planes filtered by length ()
% figure,
% myPlotPlanes(myPlanes, discardedByLength, inputFramesPath);
% title (['planes filtered by length (' num2str(ppfbl) '%)'])
% camup([0 1 0])



figure,
myPlotPlanes(myPlanes, [unique(localBoxes(1:end))], inputFramesPath);


% % % interest planes in debugging ()
% figure,
% myPlotPlanes(myPlanes, [7], inputFramesPath);
% title (['interest planes in debugging '])

%% second plane detection
for i=1:length(acceptedPlanes)
%     if(i==3)
%         disp("stop the world")
%     end
    targetPlane=acceptedPlanes(i);
    searchSpace=setdiff(acceptedPlanes,targetPlane);
    secondPlaneIndex=secondPlaneDetection(targetPlane,searchSpace,myPlanes, th_angle);
    if(secondPlaneIndex~=-1)
        myPlanes{acceptedPlanes(i)}.secondPlaneID=secondPlaneIndex;
    end
end




%% third plane detection - uses pass by reference
thirdPlaneDetection(myPlanes, acceptedPlanes, th_angle)

%% cuboid parameter estimation
% resolve just for top  planes with second and third planes defined
boxes={};
k=1;
for i=1:length(acceptedPlanes)
    if ~isempty(myPlanes{acceptedPlanes(i)}.secondPlaneID) & ...
            ~isempty(myPlanes{acceptedPlanes(i)}.thirdPlaneID)
        
        box.topPlaneID=myPlanes{acceptedPlanes(i)}.idPlane;
        box.side1PlaneID=myPlanes{acceptedPlanes(i)}.secondPlaneID;
        box.side2PlaneID=myPlanes{acceptedPlanes(i)}.thirdPlaneID;

        boxes{k}=box;
        k=k+1;
    end
end

if (~isempty(boxes))
    figure,
    for(i=1:size(boxes,2))
    [depth height width]=projectInEdge(boxes{i},myPlanes, plotFlag);
    boxes{i}.depth=depth;
    boxes{i}.height=height;
    boxes{i}.width=width;
    myPlotSingleBox(myPlanes,boxes{i},i)

    end
    myPlotSinglePlane(myPlanes{1})%plot ground
    view(2)
    xlabel 'x (m)'
    ylabel 'y (m)'
    zlabel 'z (m)'
end






return
