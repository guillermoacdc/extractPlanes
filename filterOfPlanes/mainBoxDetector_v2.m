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
antiparallelNormalIndex=[];
for i=1:numberPlanes
% for i=6:6
    planeID=i;
    inliersPath=[in_planesFolderPath + "Plane" + num2str(i-1) + "A.ply"];
    [modelParameters pc ]=loadPlaneParameters(in_planesFolderPath, frame,...
        planeID);
%     create the plane object
    myPlanes{i}=plane(scene, frame, planeID, modelParameters(1:4),...
        inliersPath, pc.Count);%scene,frame,pID,pnormal,Nmbinliers
%     classify the plane object
    myPlanes{i}.classify(pc, th_angle, groundNormal);%
%     compute geometric center and bounds of the projected point cloud
    myPlanes{i}.setGeometricCenter(pc);%all planes have a g.c.
%------------------------------------    
%     detect antiparallel normals and correct
    myPlanes{i}.correctAntiparallel(th_size);%
%     compute L1, L2 and tform
    if (myPlanes{i}.type==2)%avoid computation on non-expected planes
        continue
    else
        myPlanes{i}.measurePoseAndLength(pc, plotFlag)
    end
%     filter planes by Length
    lengthFlag=lengthFilter(myPlanes{i},lengthBounds,th_lenght);
    myPlanes{i}.setLengthFlag(lengthFlag);
end


%% descriptive statistics
k1=1;
k2=1;
k3=1;
k4=1;
for i=1:numberPlanes
    if(myPlanes{i}.type==2)
        discardedByNormal(k1)=i;
        k1=k1+1;
    end
    
    if (myPlanes{i}.lengthFlag==0)
        discardedByLength(k2)=i;
        k2=k2+1;
    end
    
    if (myPlanes{i}.lengthFlag==1)
        acceptedPlanes(k3)=i;
        k3=k3+1;
    end

	if (myPlanes{i}.antiparallelFlag==1)
        antiparallelPlanes(k4)=i;
        k4=k4+1;
    end
end
% percentage of accepted planes
pap=length(acceptedPlanes)*100/numberPlanes;
% percentage of planes filtered by normal vector
ppfbn=length(discardedByNormal)*100/numberPlanes;
% percentage of planes filtered by length
ppfbl=length(discardedByLength)*100/numberPlanes;

%--------- normalize the length of normal vector for each accepted plane
for i=1:length(acceptedPlanes)
    myPlanes{acceptedPlanes(i)}.setUnitNormal();
end
%some normals were already with unit length
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

% figure,
% myPlotBox(box,myPlanes)... in construction



return
%% plotPlanes


% planes filtered by length ()
figure,
myPlotPlanes(myPlanes,in_planesFolderPath, frame, discardedByLength);
title (['planes filtered by length (' num2str(ppfbl) '%)'])

% planes filtered by normal vector
figure,
myPlotPlanes(myPlanes,in_planesFolderPath, frame, discardedByNormal);
title (['planes filtered normal vector (' num2str(ppfbn) '%)'])

% accepted planes
figure,
myPlotPlanes(myPlanes,in_planesFolderPath, frame, acceptedPlanes);
hold on
title (['accepted planes (' num2str(pap) '%)'])

