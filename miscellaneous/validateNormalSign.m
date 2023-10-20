% computes and plot visible planes by frame. The final plot includes the
% coordinate systems qm, qh, qhmobile

clc
close all
clear

% load Session ID
sessionID=10;
k=25;%frame index
% frameID=keyframes(k);
frameID=201;
% dataSetPath=computeMainPaths(sessionID);
dataSetPath = computeReadPaths(sessionID);
filePath=fullfile(dataSetPath,['session' num2str(sessionID)], 'analyzed','HL2');
fileName='visiblePlanesByFrame';%suggested folder: analyzed/HL2/visiblePlanes.json
% load Parameters

NpointsDiagPpal=60;
tao=110;

% 1. Plane filtering parameters
    th_angle=15*pi/180;%radians
    th_size=150;%number of points
    th_lenght=10*10;%mm 10 cm - Update with tolerance_length; is in a high value (30) to pass most of the planes
    th_occlusion=1.4;%
    D_Tolerance=0.1*1000;%mm ... 0.1 m
    planeFilteringParameters=[th_lenght, th_size, th_angle, th_occlusion, D_Tolerance];
% 2. Clustering parameters
    epsilon=100;%a neighborhood search radius 10cm for the dataset
    minpts=90;% minimum number of neighbors required to identify a core point
    th_distance=40;%mm
    plotFlag=0;
    th_distance2=5000;    
    th_angle_cluster=45;
% load keyframes
keyframes=loadKeyFrames(dataSetPath, sessionID);
Nkf=length(keyframes);
% for k=1:Nkf
% for k=15:15
%     frameID=keyframes(k);
    %% cluster points by using dbscan
    display(['clustering in frame ' num2str(frameID) ])
    [clusterDescriptor, pc_h, pc_m, cameraPose]= countObjectsInPC_v7(sessionID, frameID,...
        th_angle_cluster, th_distance, th_distance2, epsilon, minpts, plotFlag);
    Nc=length(clusterDescriptor.ID);
    %% reduce the threshold distance to have a better plane model by cluster
    xyz=pc_h.Location;
%     th_distance=th_distance/2;%mm
    % figure,
    for i=1:Nc
        indexes=clusterDescriptor.rawIndex{clusterDescriptor.ID(i)};
        pc_temp=pointCloud(xyz(indexes,:));
        pc_geomCenter=mean(pc_temp.Location);
        planeModelTemp=pcfitplane(pc_temp,th_distance/2);
        clusterDescriptor.planeModel{clusterDescriptor.ID(i)}=[planeModelTemp.Parameters, pc_geomCenter];
    %     pcshow(pc_temp);
    %     hold on
    end

    %% convert cluster to plane object...
    
    planeObject=cluster2PlaneObject(pc_h,clusterDescriptor,...
        planeFilteringParameters, cameraPose);
    detectedPlanes_h=myConvertCellToVector(planeObject);
%% compute visible planes in frame comparing with gt planes
    % convert estimated poses to qm
    detectedPlanes_m=myProjectionPlaneObject_v3(detectedPlanes_h,...
                sessionID,dataSetPath);%-m world; after this line the variables 
    % a and b have the same value. consequence of pass by reference
%     (a) detectedPlanes_h, (b) detectedPlanes_m

    % load gt planes
    gtPlanes=loadGTPlanes(sessionID, frameID);
    % compare gt planes vs detectedPlanes_h
    visiblePlanes=[];
    while(~isempty(detectedPlanes_m) )
        [detectedIndex,gtIndex, visiblePlane]=computeMatchBtwnPlanes(detectedPlanes_m,...
            gtPlanes,tao,NpointsDiagPpal);
        if ~isempty(detectedIndex)
        % update detection
            detectedPlanes_m(detectedIndex)=[];
        end
        if ~isempty(gtIndex)
        % update gt
            gtPlanes(gtIndex)=[];
            visiblePlanes=[visiblePlanes; visiblePlane];
        end
    end
    sizeVisiblePlanes=size(visiblePlanes,1);
    display([num2str(sizeVisiblePlanes) ' planes are visible'])
    % generate struct
    visiblePlanesByFrame_s = convert2DVtoStructV(visiblePlanes);
    visiblePlanesBySession.(['frame' num2str(frameID)])=visiblePlanesByFrame_s;
% end
% encoded=jsonencode(visiblePlanesBySession,PrettyPrint=true);
% cd(filePath);
% fid = fopen([fileName '.json'],'w');
% fprintf(fid,'%s',encoded);
% fclose(fid);



%% plot visible planes ground truth
% convert to vector of objects planeDescriptorGTV
Nb=size(visiblePlanesByFrame_s,2);
planeDescriptorGTV=[];
for i=1:Nb
    boxID=visiblePlanesByFrame_s(i).boxID;
    sidesVector=visiblePlanesByFrame_s(i).planesID';
    planeDescriptor_temp=convertPK2PlaneObjects_v5(boxID, sessionID, sidesVector, frameID);
    planeDescriptorGTV=[planeDescriptorGTV, planeDescriptor_temp];
end


%% project camera Pose and origin to qm

%load th2m
pathTh2m=fullfile(dataSetPath,['session' num2str(sessionID)],'analyzed');
fileName='Th2m.txt';
Th2m_array=load(fullfile(pathTh2m,fileName));
Th2m=assemblyTmatrix(Th2m_array);
%project to qm
cameraPose_m=Th2m*cameraPose;
qh_m=Th2m*eye(4);



figure,
%     pcshow(pc_m);
%     hold on
    dibujarsistemaref(cameraPose_m,'c_h',250,2,10,'w');
    hold on
    dibujarsistemaref(qh_m,'h',150,2,10,'w');
    myPlotPlanes_Anotation(planeDescriptorGTV,0,'m');
    title(['Visible gt lateral planes in frame ' num2str(frameID) ', session ' num2str(sessionID) ' qm world'])
    Np=size(planeDescriptorGTV,2);
    display(['there are ' num2str(Np) '  planes - qm world'])

% removing warnings
w = warning('query','last');
id=w.identifier;
warning('off',id)