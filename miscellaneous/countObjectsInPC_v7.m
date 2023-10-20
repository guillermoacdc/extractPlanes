function [clusterDescriptor, pc_raw, pc_m, cameraPose] = countObjectsInPC_v7(sessionID, frameID, ...
    th_angle, th_distance, th_distance2, epsilon, minpts, plotFlag)
%COUNTOBJECTSINPC Counts the number of objects in a point cloud. 
%   inputs
% 1. typeObjects, 1 for top, 2 for perpendicular
% _v5: returns a struct with descriptors of each cluster: planeModel,
% _v6: returns the index to the original pointCloud in myRows_cx
% _v7: process lateral and top planes simultaneously
% sessionID, frameID, clusterID, pcCount, 

clusterDescriptor.sessionID=sessionID;
clusterDescriptor.frameID=frameID;

%% load pc from session and frame IDs
[pc_raw, cameraPose]=loadSLAMoutput_v2(sessionID,frameID); %loaded in mm
[modelGroundraw]=pcfitplane(pc_raw,th_distance);
clusterDescriptor.groundNormal=modelGroundraw.Parameters(1:3);
clusterDescriptor.groundD=modelGroundraw.Parameters(4);

%% project pc to qm coordinate system
% dataSetPath=computeMainPaths(sessionID);
dataSetPath = computeReadPaths(sessionID);
pathTh2m=fullfile(dataSetPath,['session' num2str(sessionID)],'analyzed');
fileName='Th2m.txt';
Th2m_array=load(fullfile(pathTh2m,fileName));
Th2m=assemblyTmatrix(Th2m_array);
% project
pc_m=myProjection_v3(pc_raw,Th2m);

%% delete points that fit with ground plane

[~,inlierIndices,outlierIndices]=pcfitplane(pc_m,th_distance,[0 0 1]);

% delete inliers
    xyz=pc_m.Location;
    xyz(inlierIndices,:)=[];
    pcwoutGround=pointCloud(xyz);
    myRows_pcraw=outlierIndices;

% filter points by type
    [inliersTopPlane, inliersLateralPlane]=filterPointsByType(pcwoutGround,...
        th_angle);
    myRows_topPlane=myRows_pcraw(inliersTopPlane);
    myRows_lateralPlanes=myRows_pcraw(inliersLateralPlane);
%% cluster by instance
% cluster top planes
clusterTopPlanesDescriptor=computeClusterTopPlanes(xyz, inliersLateralPlane, epsilon, ...
    minpts, [0 0 1], th_distance, th_distance2, myRows_topPlane, plotFlag);
% cluster lateral planes
clusterLateralPlanesDescriptor=computeClusterLateralPlanes(xyz, inliersTopPlane, epsilon, ...
    minpts, [0 0 1], th_distance, th_distance2, myRows_lateralPlanes, plotFlag);
% mix cluster top and lateral planes in a single cluster, add fields groundNormal, groundD
clusterDescriptor=mixClusters(clusterTopPlanesDescriptor, clusterLateralPlanesDescriptor, clusterDescriptor);

% display('stop')


end

