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
% for i=1:8
    planeID=i;
    inliersPath=[in_planesFolderPath + "Plane" + num2str(i-1) + "A.ply"];
    [modelParameters pc ]=loadPlaneParameters(in_planesFolderPath, frame,...
        planeID);
%     create the object
    myPlanes{i}=plane(scene, frame, planeID, modelParameters(1:4),...
        inliersPath, pc.Count);%scene,frame,pID,pnormal,Nmbinliers
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


%% second plane detection
for i=1:length(acceptedPlanes)
    targetPlane=acceptedPlanes(i);
    secondPlaneIndex=secondPlaneDetection(targetPlane,acceptedPlanes,myPlanes);
    if(secondPlaneIndex~=-1)
        myPlanes{acceptedPlanes(i)}.secondPlaneID=secondPlaneIndex;
    end
end


%% third plane detection
%--------- normalize the length of normal vector for each accepted plane
for i=1:length(acceptedPlanes)
    myPlanes{acceptedPlanes(i)}.setUnitNormal();
end
%some normals were already with unit length

%--------- create thirdPlaneExemplar structure. Input to the 3-d tree in the field crossP
% load detected pairs of plane index
secondPlaneT=[];
for i=1:length(acceptedPlanes)
    if(~isempty(myPlanes{acceptedPlanes(i)}.secondPlaneID))
        secondPlaneT=[secondPlaneT; myPlanes{acceptedPlanes(i)}.idPlane,...
            myPlanes{acceptedPlanes(i)}.secondPlaneID];
    end
end
% eliminate duplicates; we asume the pair (1,3) is duplicated with pair (3,1)
[uniqueIndexes ic]= myUnique(secondPlaneT);
secondPlaneT_unique=secondPlaneT(uniqueIndexes,:);
% assembly in the thirdPlaneExemplar structure
for (i=1:length(secondPlaneT_unique))
    thirdPlaneExemplar.id=secondPlaneT_unique(i,1);
    thirdPlaneExemplar.secondPlaneId=secondPlaneT_unique(i,2);
    a=myPlanes{thirdPlaneExemplar.id}.unitNormal;
    b=myPlanes{thirdPlaneExemplar.secondPlaneId}.unitNormal;
    thirdPlaneExemplar.crossPd=cross(a,b);
    tPExemplar{i}=thirdPlaneExemplar;
end

%--------- create 3-d tree
exemplarSet=zeros(length(acceptedPlanes),3);
for i=1:length(acceptedPlanes)
    exemplarSet(i,:)=myPlanes{acceptedPlanes(i)}.unitNormal;
end
modelTree=KDTreeSearcher(exemplarSet);

%--------- perform the search and save the result in myPlanes structure
for i=1:length(secondPlaneT_unique)
%     use cross product vector as a query for the kd tree
% candidates1(i)=knnsearch(modelTree,tPExemplar{i}.crossPd);
candidates1(i)=rangesearch(modelTree,tPExemplar{i}.crossPd,th_angle/100);

    if ~isempty(candidates1{i})
    % Check candidates with convexity criterion ()
        n1=myPlanes{secondPlaneT_unique(i,1)}.unitNormal;
        gc1=myPlanes{secondPlaneT_unique(i,1)}.geometricCenter;
        n2=myPlanes{acceptedPlanes(candidates1{i})}.unitNormal;
        gc2=myPlanes{acceptedPlanes(candidates1{i})}.geometricCenter;
            convFlag1=convexityCheck(n1,gc1,n2,gc2);
        n1=myPlanes{secondPlaneT_unique(i,2)}.unitNormal;
        gc1=myPlanes{secondPlaneT_unique(i,2)}.geometricCenter;
            convFlag2=convexityCheck(n1,gc1,n2,gc2);
        if(convFlag1 & convFlag2)
            % Apply proximity check (pendent)
            
            % retrieve duplicates from unique filter
            dup=find(ic==i);
            % save the thirdplane in the structure cell
            for j=1:length(dup)
                myPlanes{secondPlaneT(dup(j),1)}.thirdPlaneID=acceptedPlanes(candidates1{i});
            end
            % [secondPlaneT_unique(i,:) acceptedPlanes(candidates1{i})]
        end
    
    end

end
% acceptedPlanes(candidates1)
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

