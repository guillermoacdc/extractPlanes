function [myPlanes acceptedPlanesByFrame rejectedPlanesByFrame,...
    groundNormal groundD ]=loadPlanes_v4(myPlanes, in_planesFolderPath,...
    numberPlanes, scene, frame, parameters_PK, cameraPose, lengthBoundsP,...
    lengthBoundsTop, groundNormal, groundD, mode)

% loadPlanes_v4 function. Load planes from data in disk. This function accumulates the planes
% descriptors at each call. Each call deals with a different frame

% 1. Load basic plane descriptors in a cell of plane objects
%   1.1 identifies and extract ground plane descriptors to use as reference
%   in next steps
% 2. Add derived plane descriptors based on (1) assumptions of the scene, (2)
% previous knowledge of the scene, and (3) value of basic plane descriptors
% 3. classify planes in predefined cateogories, based on the value of some 
% of the plane's descriptors
% 4. pack planes objects into an struct called mkPlanes. Add properties: 
% camera pose, accepted planes IDs


% mode: (0,1), (w/out previous knowledge, with previous knowledge)


% parameters_PK=[th_lenght, th_size, th_angle, th_occlusion, D_Tolerance];
th_angle=parameters_PK(3);%radians
th_size=parameters_PK(2);%number of points
th_lenght=parameters_PK(1);%cm - Update with tolerance_length; is in a high value to pass most of the planes
th_occlusion=parameters_PK(4);%
D_Tolerance=parameters_PK(5);%mt

%% compute accepted planes by frame. Use planesByFrame
planesByFrame=[];
for i=1:numberPlanes
    planeID=i;
    inliersPath=[in_planesFolderPath + "Plane" + num2str(i-1) + "A.ply"];
    [modelParameters pcCount]=loadPlaneParameters(in_planesFolderPath, frame,...
        planeID);
%     create the plane object
    planesByFrame{i}=plane(scene, frame, planeID, modelParameters,...
        inliersPath, pcCount);%scene,frame,pID,pnormal,Nmbinliers
    if(planeID==1)%ground plane
        groundNormal=planesByFrame{i}.unitNormal;%warning: could be set as antiparallel
        groundD=abs(planesByFrame{i}.D);
    end
end
if (mode)
    %% include previous knowledge to classify planes
    for i=1:numberPlanes
        includePreviousKnowledge_Plane_v2(planesByFrame{i}, th_lenght, th_size, ...
            th_angle, th_occlusion, D_Tolerance, groundNormal, groundD, lengthBoundsTop,...
            lengthBoundsP, 0);
    end
    
    %% list of filtered planes
    [acceptedPlanesByFrame, discardedByNormal, discardedByLength, topOccludePlanes]=computeDescriptiveStatisticsOnPlanes_v2(planesByFrame);
    rejectedPlanesByFrame = [discardedByNormal; discardedByLength];
    [~,indexes]=unique(rejectedPlanesByFrame,'rows','stable');
    rejectedPlanesByFrame=rejectedPlanesByFrame(indexes,:);
   
%     % percentage of accepted planes
%     pap=size(acceptedPlanesByFrame,1)*100/numberPlanes;
%     % percentage of planes filtered by normal vector
%     ppfbn=size(discardedByNormal,1)*100/numberPlanes;
%     % percentage of planes filtered by length
%     ppfbl=size(discardedByLength,1)*100/numberPlanes;
else
    for i=1:numberPlanes
        acceptedPlanesByFrame(i,:)=planesByFrame{i}.getID;
    end
    rejectedPlanesByFrame=[];

end
%% accumulate objects of class plane in the struct myPlanes. One frame by field

myPlanes.(['fr' num2str(frame)]).cameraPose=cameraPose;
myPlanes.(['fr' num2str(frame)]).values=[];
myPlanes.(['fr' num2str(frame)]).acceptedPlanes=acceptedPlanesByFrame;
for i=1:numberPlanes
    myPlanes.(['fr' num2str(frame)]).values=[myPlanes.(['fr' num2str(frame)]).values planesByFrame{i}];
end

end



