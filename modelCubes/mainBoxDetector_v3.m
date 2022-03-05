clc
close all
clear 

scene=5;
frame=4;

%% define paths to load data and tresholds

in_planesFolderPath=['C:/lib/scene5/outputPlanes_t10/frame ('  num2str(frame)  ')/'];%extracted planes with efficientRANSAC
cd1=cd;
cd(in_planesFolderPath);
Files1=dir('*.ply');
cd(cd1)
numberPlanes=length(Files1);

th_angle=10;%degrees
th_size=150;%number of points
th_lenght=10;%cm
plotFlag=0;
%% iterative process to load plane descriptors from eRANSAC
for i=1:numberPlanes
    planeID=i;
    inliersPath=[in_planesFolderPath + "Plane" + num2str(i-1) + "A.ply"];
    [modelParameters pc]=loadPlaneParameters(in_planesFolderPath, frame,...
        planeID);
%     create the plane object
    myPlanes{i}=plane(scene, frame, planeID, modelParameters,...
        inliersPath, pc.Count);%scene,frame,pID,pnormal,Nmbinliers
    if(i==1)
        groundNormal=myPlanes{i}.unitNormal;%warning: could be set as antiparallel
    end
end
%% include previous knowledge to classify planes
parameters=load('scene5Planes.txt');%IDplane, IdBox, L1(cm), L2(cm), normalType
features=parameters(:,[3:5]);
L1max=max(features(:,1));
L2max=max(features(:,2));
L1min=min(features(:,1));
L2min=min(features(:,2));
lengthBounds=[L1min L1max L2min L2max];

for i=1:numberPlanes
    includePreviousKnowledge_Plane(myPlanes{i}, th_lenght, th_size, ...
        th_angle, groundNormal, lengthBounds, plotFlag);
end

%% descriptive statistics
[acceptedPlanes, discardedByNormal, discardedByLength]=computeDescriptiveStatisticsOnPlanes(myPlanes);
% percentage of accepted planes
pap=length(acceptedPlanes)*100/numberPlanes;
% percentage of planes filtered by normal vector
ppfbn=length(discardedByNormal)*100/numberPlanes;
% percentage of planes filtered by length
ppfbl=length(discardedByLength)*100/numberPlanes;

%% second plane detection
for i=1:length(acceptedPlanes)
    targetPlane=acceptedPlanes(i);
    secondPlaneIndex=secondPlaneDetection(targetPlane,acceptedPlanes,myPlanes);
    if(secondPlaneIndex~=-1)
        myPlanes{acceptedPlanes(i)}.secondPlaneID=secondPlaneIndex;
    end
end

%% third plane detection - uses pass by reference
thirdPlaneDetection(myPlanes, acceptedPlanes, th_angle)

%% cuboid parameter estimation
% resolve just for parallel planes with second and third planes defined
boxes={};
k=1;
for i=1:length(acceptedPlanes)
    if myPlanes{acceptedPlanes(i)}.type==0 & ...
            ~isempty(myPlanes{acceptedPlanes(i)}.secondPlaneID) & ...
            ~isempty(myPlanes{acceptedPlanes(i)}.thirdPlaneID)
        box.topPlaneID=myPlanes{acceptedPlanes(i)}.idPlane;
        box.side1PlaneID=myPlanes{acceptedPlanes(i)}.secondPlaneID;
        box.side2PlaneID=myPlanes{acceptedPlanes(i)}.thirdPlaneID;

        boxes{k}=box;
        k=k+1;
    end
end

if (~isempty(boxes))
    [depth height width]=projectInEdge(box,myPlanes);
    box.depth=depth;
    box.height=height;
    box.width=width;
end

%% plotPlanes

% planes filtered by length ()
figure,
myPlotPlanes(myPlanes, discardedByLength);
title (['planes filtered by length (' num2str(ppfbl) '%)'])

% planes filtered by normal vector
figure,
myPlotPlanes(myPlanes, discardedByNormal);
title (['planes filtered normal vector (' num2str(ppfbn) '%)'])

% accepted planes
figure,
myPlotPlanes(myPlanes, acceptedPlanes);
hold on
title (['accepted planes (' num2str(pap) '%)'])




return
