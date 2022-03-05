clc
close all
clear 

scene=5;
frame=5;
%% load expected values
parameters=load('scene5Planes.txt');%IDplane, IdBox, L1(cm), L2(cm), normalType
features=parameters(:,[3:5]);
L1max=max(features(:,1));
L2max=max(features(:,2));
L1min=min(features(:,1));
L2min=min(features(:,2));
lengthBounds=[L1min L1max L2min L2max];
th_lenght=5;%Tolerance in (cm)

%% define paths to load data

in_planesFolderPath=['C:/lib/scene5/outputPlanes_t10/frame ('  num2str(frame)  ')/'];%extracted planes with efficientRANSAC
cd1=cd;
cd(in_planesFolderPath);
Files1=dir('*.ply');
cd(cd1)
numberPlanes=length(Files1);

th_angle=10;
th_size=150;
groundNormal=[0 1 0];
plotFlag=0;
%% iterative process to load plane descriptors (raw and derived)
for i=1:numberPlanes
% for i=6:6
    planeID=i;
    inliersPath=[in_planesFolderPath + "Plane" + num2str(i-1) + "A.ply"];
    [modelParameters pc ]=loadPlaneParameters(in_planesFolderPath, frame,...
        planeID);
%     create the plane object
    myPlanes{i}=plane(scene, frame, planeID, modelParameters,...
        inliersPath, pc.Count);%scene,frame,pID,pnormal,Nmbinliers
%     classify the plane object
    myPlanes{i}.classify(pc, th_angle, groundNormal);%
%     update geometric center and compute bounds of the projected point
%     cloud. The update is necessary to include the projection of points to
%     the plane model before compute g.c. 
    myPlanes{i}.setLimits(pc);%set limits in each axis.
%------------------------------------    
%     detect antiparallel normals and correct
    myPlanes{i}.correctAntiparallel(th_size);%
%     compute L1, L2 and tform
    if (myPlanes{i}.type==2)%avoid computation on non-expected planes
        continue
    else
        myPlanes{i}.measurePoseAndLength(pc, plotFlag)
%         myPlotSinglePlane(myPlanes{i})
    end
%     filter planes by Length
    lengthFlag=lengthFilter(myPlanes{i},lengthBounds,th_lenght);
    myPlanes{i}.setLengthFlag(lengthFlag);
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


[depth height width]=projectInEdge(box,myPlanes);
box.depth=depth;
box.height=height;
box.width=width;

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
