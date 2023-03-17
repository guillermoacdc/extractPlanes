function [myPlanes, acceptedPlanesByFrame, rejectedPlanesByFrame,...
    groundNormal, groundD ]=loadExtractedPlanesByFrame(myPlanes, in_planesFolderPath,...
    numberPlanes, scene, frame, tresholdsV, cameraPose, lengthBoundsP,...
    lengthBoundsTop, groundNormal, groundD, mode)

% loadExtractedPlanesByFrame function. Load planes that belong to a single 
% frame, from data in disk. This function accumulates the planes
% descriptors at each call. Each call deals with a single and different frame

% 1. Load basic plane descriptors in a cell of plane objects
%   1.1 identifies and extract ground plane descriptors to use as reference
%   in next steps
% 2. Include previous knowledge to classify planes
% 3. classify planes in predefined cateogories, based on the value of some 
% of the plane's descriptors
% 4. pack planes objects into an struct called mkPlanes. Add properties: 
% camera pose, accepted planes IDs


% mode: (0,1), (w/out previous knowledge, with previous knowledge)


% decodify thresholds
th_angle=tresholdsV(3);%radians
th_size=tresholdsV(2);%number of points
th_lenght=tresholdsV(1);%cm - Update with tolerance_length; is in a high value to pass most of the planes
th_occlusion=tresholdsV(4);%
D_Tolerance=tresholdsV(5);%mt


planesByFrame=[];
for i=1:numberPlanes
    planeID=i;
    inliersPath=[in_planesFolderPath + "Plane" + num2str(i-1) + "A.ply"];
    [modelParameters pcCount]=loadPlaneParameters(in_planesFolderPath, frame,...
        planeID);
%% 1. Load basic plane descriptors in a cell of plane objects
    planesByFrame{i}=plane(scene, frame, planeID, modelParameters,...
        inliersPath, pcCount);%scene,frame,pID,pnormal,Nmbinliers
%   1.1 identifies and extract ground plane descriptors to use as reference
%   in next steps
    if(planeID==1)%ground plane
        groundNormal=planesByFrame{i}.unitNormal;%warning: could be set as antiparallel
        groundD=abs(planesByFrame{i}.D);
    end
end

if (mode)
%% 2. Include previous knowledge to classify planes
    for i=1:numberPlanes
        fillDerivedDescriptors_PK(planesByFrame{i}, th_lenght, th_size, ...
            th_angle, th_occlusion, D_Tolerance, groundNormal, groundD, lengthBoundsTop,...
            lengthBoundsP, 0);
    end
%% 3. classify planes in predefined cateogories, based on the value of some of the plane's descriptors
    [acceptedPlanesByFrame, discardedByNormal, discardedByLength, topOccludePlanes]=classifyPlanes(planesByFrame);
    rejectedPlanesByFrame = [discardedByNormal; discardedByLength];
    [~,indexes]=unique(rejectedPlanesByFrame,'rows','stable');
    rejectedPlanesByFrame=rejectedPlanesByFrame(indexes,:);
else
    for i=1:numberPlanes
        acceptedPlanesByFrame(i,:)=planesByFrame{i}.getID;
    end
    rejectedPlanesByFrame=[];

end

%% 4. pack planes objects into an struct called mkPlanes. Add properties:  camera pose, accepted planes IDs

myPlanes.(['fr' num2str(frame)]).cameraPose=cameraPose;
myPlanes.(['fr' num2str(frame)]).values=[];
myPlanes.(['fr' num2str(frame)]).acceptedPlanes=acceptedPlanesByFrame;
for i=1:numberPlanes
    myPlanes.(['fr' num2str(frame)]).values=[myPlanes.(['fr' num2str(frame)]).values planesByFrame{i}];
end

end



