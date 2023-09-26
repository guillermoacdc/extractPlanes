function planeObjectV = cluster2PlaneObject(pc_m,clusterDescriptor,tresholdsV, cameraPose)
%CLUSTER2PLANEOBJECT Summary of this function goes here
%   Detailed explanation goes here
% decodify thresholds
th_angle=tresholdsV(3);%radians
th_size=tresholdsV(2);%number of points
th_lenght=tresholdsV(1);%mm - Update with tolerance_length; is in a high value to pass most of the planes
th_occlusion=tresholdsV(4);%
D_Tolerance=tresholdsV(5);%mm
groundNormal=clusterDescriptor.groundNormal;
groundD=clusterDescriptor.groundD;
compensateFactor=0;
plotFlag=0;

sessionID=clusterDescriptor.sessionID;
frameID=clusterDescriptor.frameID;
dataSetPath=computeMainPaths(sessionID);
[lengthBoundsTop,  lengthBoundsP]=computeLengthBounds_v2(dataSetPath, sessionID, frameID);

Nc=length(clusterDescriptor.ID);
xyz=pc_m.Location;
for i=1:Nc
    
    planeID=clusterDescriptor.ID(i);
    pc=pointCloud(xyz(clusterDescriptor.rawIndex{planeID},:));
    modelParameters=clusterDescriptor.planeModel{planeID};
    Nmbinliers=size(clusterDescriptor.rawIndex{planeID},1);
    planeObjectV{i}=plane(sessionID, frameID, planeID,modelParameters, [],Nmbinliers);
    fillDerivedDescriptors_Annotation(pc, planeObjectV{i},th_lenght, th_size, th_angle,...
        th_occlusion,D_Tolerance,groundNormal,groundD,lengthBoundsTop,...
        lengthBoundsP, plotFlag, compensateFactor, cameraPose);
end

% % eliminate planes by empty tform
% Nplanes=length(planeObjectV);
% discardedPlanesIndex=[];
% for i=1:Nplanes
%     if isempty(planeObjectV{i}.tform)
%         discardedPlanesIndex=[discardedPlanesIndex i];
%     end
% end
% planeObjectV(discardedPlanesIndex)=[];

% eliminate planes by flags
% classify planes in predefined cateogories, based on the value of some of the plane's descriptors
    [acceptedPlanesByFrame, discardedByNormal, discardedByLength]=classifyPlanes(planeObjectV);
    rejectedPlanesByFrame = [discardedByNormal; discardedByLength];
    [~,indexes]=unique(rejectedPlanesByFrame,'rows','stable');
    rejectedPlanesByFrame=rejectedPlanesByFrame(indexes,:);
if ~isempty(rejectedPlanesByFrame)
    planeObjectV(rejectedPlanesByFrame(:,2))=[];
end
% correct antiparallel normals

end

