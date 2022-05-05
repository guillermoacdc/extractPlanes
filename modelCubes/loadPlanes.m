function [myPlanes acceptedPlanesByFrame groundNormal groundD i_init]=loadPlanes(myPlanes, in_planesFolderPath, numberPlanes, scene, frame, parameters_PK, lengthBounds, groundNormal, groundD, mode)
% Load planes from data in disk. This function accumulates the planes
% descriptors at each call. Each call deals with a different frame

% mode: (0,1), (w/out previous knowledge, with previous knowledge)


% parameters_PK=[th_lenght, th_size, th_angle, th_occlusion, D_Tolerance];
th_angle=parameters_PK(3);%radians
th_size=parameters_PK(2);%number of points
th_lenght=parameters_PK(1);%cm - Update with tolerance_length; is in a high value to pass most of the planes
th_occlusion=parameters_PK(4);%
D_Tolerance=parameters_PK(5);%mt

i_offset=size(myPlanes,2);



%% compute accepted planes by frame. Use planesByFrame
planesByFrame=[];
for i=1:numberPlanes
    planeID=i;
    inliersPath=[in_planesFolderPath + "Plane" + num2str(i-1) + "A.ply"];
    [modelParameters pc]=loadPlaneParameters(in_planesFolderPath, frame,...
        planeID);
%     create the plane object
    planesByFrame{i}=plane(scene, frame, planeID, modelParameters,...
        inliersPath, pc.Count);%scene,frame,pID,pnormal,Nmbinliers
    if(planeID==1)%ground plane
        groundNormal=planesByFrame{i}.unitNormal;%warning: could be set as antiparallel
        groundD=abs(planesByFrame{i}.D);
    end
end
if (mode)
    %% include previous knowledge to classify planes
    for i=1:numberPlanes
        includePreviousKnowledge_Plane(planesByFrame{i}, th_lenght, th_size, ...
            th_angle, th_occlusion, D_Tolerance, groundNormal, groundD, lengthBounds, 0);
    end
    
    %% descriptive statistics
    [acceptedPlanesByFrame, discardedByNormal, discardedByLength, topOccludePlanes]=computeDescriptiveStatisticsOnPlanes(planesByFrame);
    % percentage of accepted planes
    pap=length(acceptedPlanesByFrame)*100/numberPlanes;
    % percentage of planes filtered by normal vector
    ppfbn=length(discardedByNormal)*100/numberPlanes;
    % percentage of planes filtered by length
    ppfbl=length(discardedByLength)*100/numberPlanes;
else
    acceptedPlanesByFrame=1:numberPlanes;
end
%% accumulate objects of class plane in the cell myPlanes
for i=1:numberPlanes
    myPlanes{i_offset+i}=planesByFrame{i};
end
i_init=i_offset;

end



% %% iterative process to load plane descriptors from eRANSAC
% for i=1:numberPlanes
%     planeID=i;
%     inliersPath=[in_planesFolderPath + "Plane" + num2str(i-1) + "A.ply"];
%     [modelParameters pc]=loadPlaneParameters(in_planesFolderPath, frame,...
%         planeID);
% %     create the plane object
%     myPlanes{i+i_offset}=plane(scene, frame, planeID, modelParameters,...
%         inliersPath, pc.Count);%scene,frame,pID,pnormal,Nmbinliers
%     if(planeID==1 && i_offset==0)%ground plane
%         groundNormal=myPlanes{i}.unitNormal;%warning: could be set as antiparallel
%         groundD=abs(myPlanes{i}.D);
%     end
% end
% 
% if (mode)
%     %% include previous knowledge to classify planes
%     
%     for i=1:numberPlanes
%         includePreviousKnowledge_Plane(myPlanes{i+i_offset}, th_lenght, th_size, ...
%             th_angle, th_occlusion, D_Tolerance, groundNormal, groundD, lengthBounds, 0);
%     end
%     
%     %% descriptive statistics
%     [acceptedPlanes, discardedByNormal, discardedByLength topOccludePlanes]=computeDescriptiveStatisticsOnPlanes(myPlanes);
%     % percentage of accepted planes
%     pap=length(acceptedPlanes)*100/numberPlanes;
%     % percentage of planes filtered by normal vector
%     ppfbn=length(discardedByNormal)*100/numberPlanes;
%     % percentage of planes filtered by length
%     ppfbl=length(discardedByLength)*100/numberPlanes;
% else
%     acceptedPlanes=1:numberPlanes;
% end
