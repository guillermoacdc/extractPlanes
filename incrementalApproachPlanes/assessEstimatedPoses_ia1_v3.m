% First version of an incremental approach. In the merge stage performs a
% selection of planes. This selection is based on criteria of distance
% between camera and object, area of the candidates and intersection over
% union metrics. 
% v3: select between pair of planes with IoU greater than a threshold
clc
close all
clear

sessionID=2;
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
th_IoU=0.2;% percent
th_coplanarDistance=20;%mm
%% parameters 5. temporal filtering
%define an empty vector of type particle
particlesVector(1)=particle(1,[0 0 0], 1, 5);
particlesVector(1)=[];
% radii=computeRaddi(dataSetPath,sessionID,1,planeType);
radii=15;%mm - initial value. The raddi changes every time a box is extracted from consolidation zone

windowSize=5;%frames
th_detections=0.3;%percent - not used in version 1

%% processing
% computing keyframes for the session
keyframes=loadKeyFrames(dataSetPath,sessionID);

Nframes=length(keyframes);
Ntao=length(tao_v);

% performing the computation for each frame
estimatedPoses.tao=tao_v;
globalPlanesPrevious=[];
globalPlanes=[];
localPlanes=[];
for i=1:Nframes
    tic;% init timer
    frameID=keyframes(i);
    radii=computeRaddi(dataSetPath,sessionID,frameID,planeType);%use of pps
    logtxt=['Assessing detections in frame ' num2str(frameID) ' with radii ' num2str(radii) ' mm. i=' num2str(i) '/' num2str(length(keyframes))];
    disp(logtxt);
%%     writeProcessingState(logtxt,evalPath,sessionID);

    gtPoses=loadInitialPose(dataSetPath,sessionID,frameID);
    estimatedPlanesfr=loadExtractedPlanes(dataSetPath,sessionID,frameID,...
        PCpath, tresholdsV);%returns a struct with a property frx - h world
%     if i==21
%         disp("stop mark")
%     end
%% extract target identifiers based on type of plane
    estimatedPlanesID=extractTargetIDs(estimatedPlanesfr,frameID,planeType);
%% forget old planes
        if mod(i,windowSize)==0 %& i>=2*windowSize
            if (i-windowSize)>=1
                windowInit=keyframes(i-windowSize);
            else
                windowInit=keyframes(1);
            end
            
            globalPlanes=updatePresence_v2(globalPlanes,particlesVector,windowInit, th_detections);
        end
%% fill estimatedPoses output
    if isempty(estimatedPlanesID)
        estimatedPoses.(['frame' num2str(frameID)])=[];%empty frames are frames where detections were null
        toc; %close the timer
        continue
    else
%% convert struct to vector localPlanes
        localPlanes=loadPlanesFromIDs(estimatedPlanesfr,estimatedPlanesID);%vector in h world
% compute presence of a particle using localPlanes
        [particlesVector, localPlanes]= computeParticlesVector_v2(localPlanes,...
                    particlesVector, radii, frameID);
        
%% update globalPlanesPrevious vector        
        if isempty(globalPlanesPrevious)
            globalPlanesPrevious=clonePlaneObject(localPlanes);%h-world
        else
            globalPlanesPrevious=clonePlaneObject(globalPlanes);
        end
%% perform the merge        
        globalPlanes=mergeIntoGlobalPlanes(localPlanes,globalPlanesPrevious,tao_merg,theta_merg);%h-world
        globalPlanes=mergePlanesOfASingleFrame_a1(globalPlanes, th_IoU, th_coplanarDistance);

% associate particles with global planes
globalPlanes = associateParticlesWithGlobalPlanes(globalPlanes,particlesVector, radii);

ProcessingTime=toc;%stop the timer

% project estimated poses to qm and compute estimatedPoses struct. The rest of properties is kept
        globalPlanes_t=clonePlaneObject(globalPlanes);
        estimatedGlobalPlanesID=extractIDsFromVector(globalPlanes_t);
        estimatedPoses=computeEstimatedPosesStruct_v2(globalPlanes_t,gtPoses,...
            sessionID,frameID,estimatedGlobalPlanesID,tao_v,dataSetPath,...
            NpointsDiagPpal,estimatedPoses, ProcessingTime);

    end

%     
end
% write json file to disk

mySaveStruct2JSONFile(estimatedPoses,fileName,evalPath,sessionID);
figure,
    myPlotPlanes_v3(globalPlanes,0);
    title(['global planes  in frame ' num2str(frameID)])
return 

% figure,
%     myPlotPlanes_v3(localPlanes,0);
%     title(['local planes in frame ' num2str(frameID)])
% 

% 
% figure,
%     myPlotPlanes_v3(globalPlanesPrevious,0);
%     title(['previous global planes in frame ' num2str(frameID)])




% removing warnings
w = warning('query','last');
id=w.identifier;
warning('off',id)
