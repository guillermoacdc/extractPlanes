clc
close all
clear 


%% define paths to load data

%% create the object and classify
frame=5;
in_planesFolderPath=['C:/lib/outputPlanes_t10/frame ('  num2str(frame)  ')/'];%extracted planes with efficientRANSAC
cd1=cd;
cd(in_planesFolderPath);
Files1=dir('*.ply');
cd(cd1)
numberPlanes=length(Files1);


th_angle=10;
th_size=200;
groundNormal=[0 1 0];
plotFlag=0;
% iterative process
antiparallelNormalIndex=[];
for i=1:numberPlanes
% for i=6:7
    planeID=i;
    [modelParameters pc ]=loadPlaneParameters(in_planesFolderPath, frame, planeID);
%     create the object
    myPlanes{i}=plane(modelParameters(1), modelParameters(2),...
        modelParameters(3), modelParameters(4), pc.Count);
%     classify the object
    myPlanes{i}.classify(th_angle, groundNormal);%
    antiparallelNormalIndex(i)=myPlanes{i}.correctAntiparallel(th_size);%
%     compute L1, L2 and tform
    if (myPlanes{i}.type==2)%avoid computation on non-expected planes
        continue
    else
        myPlanes{i}.measurePoseAndLength(pc, plotFlag)
    end
end
return

% create the object
planeID=14;
[modelParameters pc ]=loadPlaneParameters(in_planesFolderPath, frame, planeID);
myPlane=plane(modelParameters(1), modelParameters(2),...
    modelParameters(3), modelParameters(4), pc.Count);
myPlane.classify(th_angle);%
myPlane.correctAntiparallel(th_size);%