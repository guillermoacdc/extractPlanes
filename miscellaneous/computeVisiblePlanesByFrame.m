clc
close all
clear

% parameters
sessionID=10;
dataSetPath=computeMainPaths(1);
% kf=loadKeyFrames(dataSetPath,sessionID);
% frameID=kf(14);
frameID=12;%12,101,205
NpointsDiagPpal=60;
tao=110;

th_angle=45;
epsilon=100;%a neighborhood search radius 10cm for the dataset
minpts=90;% minimum number of neighbors required to identify a core point
th_distance=40;%mm
plotFlag=0;
th_distance2=5000;
% test
[clusterDescriptor, pc_h, pc_m, cameraPose]= countObjectsInPC_v7(sessionID, frameID,...
    th_angle, th_distance, th_distance2, epsilon, minpts, plotFlag);
numberOfObjects=length(clusterDescriptor.ID);
% outputs and figures

% plot extracted clusters from  pc_m
Nc=length(clusterDescriptor.ID);

xyz=pc_h.Location;
% reduce the threshold distance to have a better plane model by cluster
th_distance=th_distance/2;%mm
figure,
for i=1:Nc
    indexes=clusterDescriptor.rawIndex{clusterDescriptor.ID(i)};
    pc_temp=pointCloud(xyz(indexes,:));
    pc_geomCenter=mean(pc_temp.Location);
    planeModelTemp=pcfitplane(pc_temp,th_distance);
    clusterDescriptor.planeModel{clusterDescriptor.ID(i)}=[planeModelTemp.Parameters, pc_geomCenter];
    pcshow(pc_temp);
    hold on
end

% convert cluster to plane object...
% 1. Plane filtering parameters
th_angle=15*pi/180;%radians
th_size=150;%number of points
th_lenght=10*10;%mm 10 cm - Update with tolerance_length; is in a high value (30) to pass most of the planes
th_occlusion=1.4;%
D_Tolerance=0.1*1000;%mm ... 0.1 m
planeFilteringParameters=[th_lenght, th_size, th_angle, th_occlusion, D_Tolerance];


planeObject=cluster2PlaneObject(pc_h,clusterDescriptor,...
    planeFilteringParameters, cameraPose);
detectedPlanes_h=myConvertCellToVector(planeObject);
figure,
    pcshow(pc_h);
    hold on
    myPlotPlanes_Anotation(detectedPlanes_h,1,'h');
    hold on
    dibujarsistemaref(eye(4),'h',150,2,10,'w');
    dibujarsistemaref(cameraPose,'h_m',150,2,10,'w');
title(['Visible lateral planes in frame ' num2str(frameID) ', session ' num2str(sessionID)])
Np=size(detectedPlanes_h,2);
display(['there are ' num2str(Np) '  planes - qh world'])


%% compute visible planes in frame comparing with gt planes
% convert estimated poses to qm
detectedPlanes_m=myProjectionPlaneObject_v3(detectedPlanes_h,...
            sessionID,dataSetPath);%-m world
% validating projection by graphics
figure,
    pcshow(pc_m);
    hold on
    myPlotPlanes_Anotation(detectedPlanes_m,1,'m');
title(['Visible lateral planes in frame ' num2str(frameID) ', session ' num2str(sessionID) ' qm world'])
Np=size(detectedPlanes_m,2);
display(['there are ' num2str(Np) '  planes - qm world'])

% return

% load gt planes
gtPlanes=loadGTPlanes(sessionID, frameID);
%% compare gt planes vs detectedPlanes_h

% counter=1;
visiblePlanes=[];
while(~isempty(detectedPlanes_h) )
    [detectedID,gtID, visiblePlane]=computeMatchBtwnPlanes(detectedPlanes_h,...
        gtPlanes,tao,NpointsDiagPpal);
    %     [eADD_m] = compute_eADD_v3(detectedPlanes_m, ...
    %     gtPlanes,  tao, NpointsDiagPpal);
    if ~isempty(detectedID)
    % update detection
        detectedPlanes_h(detectedID)=[];
    end
    if ~isempty(gtID)
    % update gt
        gtPlanes(gtID)=[];
        visiblePlanes=[visiblePlanes; visiblePlane];
    end
%     counter=counter+1;
end

%% generate and plot visible planes ground truth
% generate
visiblePlanes_s = convert2DVtoStructV(visiblePlanes);
Nb=size(visiblePlanes_s,2);
planeDescriptorGTV=[];
for i=1:Nb
    boxID=visiblePlanes_s(i).boxID;
    sidesVector=visiblePlanes_s(i).planesID';
    planeDescriptor_temp=convertPK2PlaneObjects_v5(boxID, sessionID, sidesVector, frameID);
    planeDescriptorGTV=[planeDescriptorGTV, planeDescriptor_temp];
end

figure,
    pcshow(pc_m);
    hold on
    myPlotPlanes_Anotation(planeDescriptorGTV,0,'m');
title(['Visible gt lateral planes in frame ' num2str(frameID) ', session ' num2str(sessionID) ' qm world'])
Np=size(planeDescriptorGTV,2);
display(['there are ' num2str(Np) '  planes - qm world'])
