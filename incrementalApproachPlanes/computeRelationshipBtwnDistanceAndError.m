% First version of an incremental approach. In the merge stage performs a
% selection of planes. This selection is based on criteria of distance
% between camera and object, area of the candidates and intersection over
% union metrics. 
clc
close all
clear

sessionID=10;
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
%% parameters of temporal filtering
%define an empty vector of type particle
particlesVector(1)=particle(1,[0 0 0], 100, 150, 5);
particlesVector(1)=[];
radii=35;%mm
windowSize=20;%frames
th_detections=0.3;%percent - not used in version 1

%% processing
% computing keyframes for the session
keyframes=loadKeyFrames(dataSetPath,sessionID);

Nframes=length(keyframes);
Ntao=length(tao_v);

% performing the computation for each frame
estimatedPoses.tao=tao_v;
globalPlanesPrevious=[];
% vectors to plot distance vs eADD
distanceAcc=[];
eADD_dist=[];
fitnessVector=[];
for i=1:Nframes
    frameID=keyframes(i);


    logtxt=['Assessing detections in frame ' num2str(frameID)];
    disp(logtxt);
    %     writeProcessingState(logtxt,evalPath,sessionID);

    gtPoses=loadInitialPose(dataSetPath,sessionID,frameID);
    estimatedPlanesfr=loadExtractedPlanes(dataSetPath,sessionID,frameID,...
        PCpath, tresholdsV);%returns a struct with a property frx - h world
    if frameID==16
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
        distanceVector=extractDistanceCameraFromVector(localPlanes);
%         [min(distanceVector) max(distanceVector)]
% compute presence of a particle using localPlanes
% particlesVector = computeParticlesVector(localPlanes,...
%             particlesVector, radii, frameID);
% associate particles with global planes
% globalPlanes = associateParticlesWithGlobalPlanes(globalPlanes,particlesVector, radii);

%         if mod(i,windowSize)==0 & i>=2*windowSize
%             globalPlanes=updatePresence(globalPlanes,particlesVector,windowSize, frameID, th_detections);
%         end

% project estimated poses to qm and compute estimatedPoses struct. The rest of properties is kept
        localPlanes_t=clonePlaneObject(localPlanes);
        estimatedlocalPlanesID=extractIDsFromVector(localPlanes_t);
        estimatedPoses=computeEstimatedPosesStruct(localPlanes_t,gtPoses,...
            sessionID,frameID,estimatedlocalPlanesID,tao_v,evalPath,dataSetPath,...
            NpointsDiagPpal,estimatedPoses);
% save distance and eADD
    distanceAcc=[distanceAcc; distanceVector];
    eADD_dist=[eADD_dist; min(estimatedPoses.(['frame' num2str(frameID)]).eADD.tao50,[],2)];%for tao=50 
    fitnessVector=[fitnessVector; extractFitnessFromVector(localPlanes)];
    end

%     
end

figure,
    stem(distanceAcc,eADD_dist)
    xlabel 'distance (mm)'
    ylabel 'e_{ADD}'
    grid
    title (['session ID=' num2str(sessionID)])
return

figure,
    myPlotPlanes_v2(estimatedPlanesfr,estimatedPlanesfr.fr31.acceptedPlanes,0);
    title(['local planes in frame ' num2str(frameID)])
    hold on
    Tc=estimatedPlanesfr.fr31.cameraPose;
    dibujarsistemaref(Tc,'h',150,2,10,'w');
    

figure,
    myPlotPlanes_v3(localPlanes,0);
    title(['local planes in frame ' num2str(frameID)])

figure,
    myPlotPlanes_v3(globalPlanes,0);
    title(['global planes  in frame ' num2str(frameID)])

figure,
    myPlotPlanes_v3(globalPlanesPrevious,0);
    title(['previous global planes in frame ' num2str(frameID)])

% write json file to disk
return
mySaveStruct2JSONFile(estimatedPoses,fileName,evalPath,sessionID);



% removing warnings
w = warning('query','last');
id=w.identifier;
warning('off',id)
