% Second version of an incremental approach. In the merge stage performs a
% a hybrid strategy which includes: (1) selection of planes or (2) creation 
% of new planes. The second strategy includes (1)  creation of a new point 
% cloud through fusion of two or more point clouds, (2) the processment of 
% the new pc to compute the plane properties, (3) the managmente of a
% buffer to keep the record of components in new pointclouds/planes

clc
close all
clear

sessionID=10;
[dataSetPath,evalPath,PCpath] = computeMainPaths(sessionID);
fileName='estimatedPoses_ia2.json';

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
bufferComposedPlanes={};
[lengthBoundsTop, lengthBoundsP] =computeLengthBounds_v2(dataSetPath, sessionID);%no actualizar según cajas en escena; esa info no está disponible en cada frame para el extractor de cajas
for i=1:Nframes
% for i=8:24
    frameID=keyframes(i);
    logtxt=['Assessing detections in frame ' num2str(frameID)];
    disp(logtxt);
%     if frameID==10
%         disp('control point from assessEstimatedPoses_ia2')
%     end

    %     writeProcessingState(logtxt,evalPath,sessionID);
    gtPoses=loadInitialPose(dataSetPath,sessionID,frameID);
    estimatedPlanesfr=loadExtractedPlanes(dataSetPath,sessionID,frameID,...
        PCpath, tresholdsV);%returns a struct with a property frx - h world

    % extract target identifiers based on type of plane
    estimatedPlanesID=extractTargetIDs(estimatedPlanesfr,frameID,planeType);

% fill estimatedPoses output
    if isempty(estimatedPlanesID)
        estimatedPoses.(['frame' num2str(frameID)])=[];%empty frames are frames where detections were null
        continue
    else
% convert struct to vector localPlanes
        localPlanes=loadPlanesFromIDs(estimatedPlanesfr,estimatedPlanesID);%vector in h world
        
        [localPlanes,bufferComposedPlanes]=mergePlanesOfASingleFrame(localPlanes,bufferComposedPlanes,tresholdsV,...
            lengthBoundsTop, lengthBoundsP, sessionID);%to merge cases type4 in a single frame

% update globalPlanesPrevious vector        
        if isempty(globalPlanesPrevious)
            globalPlanesPrevious=clonePlaneObject(localPlanes);%h-world
        else
            globalPlanesPrevious=clonePlaneObject(globalPlanes);
        end
% perform the merge        
%         globalPlanes=mergeIntoGlobalPlanes(localPlanes,globalPlanesPrevious,tao_merg,theta_merg);%h-world

        [globalPlanes, bufferComposedPlanes]=mergeIntoGlobalPlanes_v2(localPlanes,...
            globalPlanesPrevious,tao_merg,theta_merg, lengthBoundsTop,...
            lengthBoundsP,bufferComposedPlanes, tresholdsV);%h-world
% project estimated poses to qm and compute estimatedPoses struct. The rest of properties is kept
        globalPlanes_t=clonePlaneObject(globalPlanes);
        estimatedGlobalPlanesID=extractIDsFromVector(globalPlanes_t);
        estimatedPoses=computeEstimatedPosesStruct(globalPlanes_t,gtPoses,...
            sessionID,frameID,estimatedGlobalPlanesID,tao_v,evalPath,dataSetPath,...
            NpointsDiagPpal,estimatedPoses);

    end

%     
end


return
% write json file to disk
mySaveStruct2JSONFile(estimatedPoses,fileName,evalPath,sessionID);

% figure,
%     myPlotPlanes_v2(estimatedPlanesfr,estimatedPlanesfr.fr27.acceptedPlanes,0);
%     title(['local planes in frame ' num2str(frameID)])
%     hold on
%     dibujarsistemaref(eye(4),'m',150,2,10,'w');
    

figure,
    myPlotPlanes_v3(localPlanes,0);
    title(['local planes in frame ' num2str(frameID)])

figure,
    myPlotPlanes_v3(globalPlanes,0);
    title(['global planes  in frame ' num2str(frameID)])


% removing warnings
w = warning('query','last');
id=w.identifier;
warning('off',id)
