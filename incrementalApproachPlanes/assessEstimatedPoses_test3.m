% modification of functions to avoid passing a field called frame: v2
% first version of an incremental approach. 
clc
close all
clear

sessionID=3;
[dataSetPath,evalPath,PCpath] = computeMainPaths(sessionID);
fileName='estimatedPoses_ia1.json';

planeType=0;%{0 for xzPlanes, 1 for xyPlanes, 2 for zyPlanes} in qh_c coordinate system
%% parameters 2. Plane filtering (based on previous knowledge) and pose/length estimation. 
th_angle=15*pi/180;%radians
th_size=150;%number of points
th_lenght=10*10;%mm 10 cm - Update with tolerance_length; is in a high value (30) to pass most of the planes
th_occlusion=1.4;%
D_Tolerance=0.1*1000;%mm ... 0.1 m
tresholdsV=[th_lenght, th_size, th_angle, th_occlusion, D_Tolerance];
%% parameters 3.  Assesment Pose with e_ADD
tao_v=10:10:50;
NpointsDiagPpal=20;
%% parameters 4. Merging planes between frames
% parameters of merging planes - used in the function computeTypeOfTwin
tao_merg=50;% mm
theta_merg=0.5;%in percentage

%% processing
% computing keyframes for the session
keyframes=loadKeyFrames(dataSetPath,sessionID);

Nframes=length(keyframes);
Ntao=length(tao_v);

% performing the computation for each frame
estimatedPoses.tao=tao_v;
globalPlanesPrevious=[];
for i=1:Nframes
% for i=5:10
    frameID=keyframes(i);
    logtxt=['Assessing detections in frame ' num2str(frameID)];
    disp(logtxt);
    %     writeProcessingState(logtxt,evalPath,sessionID);

    gtPoses=loadInitialPose(dataSetPath,sessionID,frameID);
    estimatedPlanesfr=loadExtractedPlanes(dataSetPath,sessionID,frameID,...
        PCpath, tresholdsV);%returns a struct with a property frx - h world
    if frameID==5
        disp("stop mark")
    end
    % extract target identifiers based on type of plane
    estimatedPlanesID=extractTargetIDs(estimatedPlanesfr,frameID,planeType);

% fill estimatedPoses output
    if isempty(estimatedPlanesID)
        estimatedPoses.(['frame' num2str(frameID)])=[];%empty frames are frames where detections were null
        continue
    else
% convert struct to vector localPlanes
        localPlanes=loadPlanesFromIDs(estimatedPlanesfr,estimatedPlanesID);%vector in h world
% update globalPlanesPrevious vector        
        if isempty(globalPlanesPrevious)
            globalPlanesPrevious=clonePlaneObject(localPlanes);%h-world
        else
            globalPlanesPrevious=clonePlaneObject(globalPlanes);
        end
% perform the merge        
        globalPlanes=mergeIntoGlobalPlanes(localPlanes,globalPlanesPrevious,tao_merg,theta_merg);%h-world
% project estimated poses to qm and compute estimatedPoses struct. The rest of properties is kept
%         globalPlanes_t=clonePlaneObject(globalPlanes);
%         estimatedGlobalPlanesID=extractIDsFromVector(globalPlanes_t);
%         estimatedPoses=computeEstimatedPosesStruct(globalPlanes_t,gtPoses,...
%             sessionID,frameID,estimatedGlobalPlanesID,tao_v,evalPath,dataSetPath,...
%             NpointsDiagPpal,estimatedPoses);

    end

%     
end

figure,
    myPlotPlanes_v2(estimatedPlanesfr,estimatedPlanesfr.fr27.acceptedPlanes,0);
    title(['local planes in frame ' num2str(frameID)])
    hold on
    dibujarsistemaref(eye(4),'m',150,2,10,'w');
    

figure,
    myPlotPlanes_v3(localPlanes,1);
    title(['local planes in frame ' num2str(frameID)])
    hold on
    dibujarsistemaref(eye(4),'h',200,2,10,'b')
figure,
    myPlotPlanes_v3(globalPlanesPrevious,0);
    title(['global planes previous in frame ' num2str(frameID)])

% write json file to disk
return
mySaveStruct2JSONFile(estimatedPoses,fileName,evalPath,sessionID);



% removing warnings
w = warning('query','last');
id=w.identifier;
warning('off',id)
