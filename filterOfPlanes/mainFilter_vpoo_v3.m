clc
close all
clear 

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

in_planesFolderPath=['C:/lib/outputPlanes_t10/frame ('  num2str(frame)  ')/'];%extracted planes with efficientRANSAC
cd1=cd;
cd(in_planesFolderPath);
Files1=dir('*.ply');
cd(cd1)
numberPlanes=length(Files1);

th_angle=10;
th_size=200;
groundNormal=[0 1 0];
plotFlag=1;
%% iterative process
antiparallelNormalIndex=[];
% for i=1:numberPlanes
for i=1:8
    planeID=i;
    [modelParameters pc ]=loadPlaneParameters(in_planesFolderPath, frame, planeID);
%     create the object
    myPlanes{i}=plane(modelParameters(1), modelParameters(2),...
        modelParameters(3), modelParameters(4), pc.Count);
%     classify the object
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

return

%% plot results


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

% planes filtered by length ()
figure,
myPlotPlanes(myPlanes,in_planesFolderPath, frame, discardedByLength);
title ('planes filtered by length ')

% planes filtered by normal vector
figure,
myPlotPlanes(myPlanes,in_planesFolderPath, frame, discardedByNormal);
title ('planes filtered normal vector ')

% accepted planes
figure,
myPlotPlanes(myPlanes,in_planesFolderPath, frame, acceptedPlanes);
title ('accepted planes')
