clc
close all
clear 


sessionID=5;
planeType=0;
[dataSetPath,~,PCpath] = computeMainPaths(sessionID);

% parameters of detection
th_angle=15*pi/180;%radians
th_size=150;%number of points
th_lenght=10;% 10 cm - Update with tolerance_length; is in a high value (30) to pass most of the planes
th_occlusion=1.4;%
D_Tolerance=0.1;%mt
tresholdsV=[th_lenght, th_size, th_angle, th_occlusion, D_Tolerance];
% parameters of merging planes - used in the function computeTypeOfTwin
tao=50/1000;%in meters----50mm
theta=0.5;%in percentage

%% create myPlanes cell with two frames
keyFrames=[2 5];
% keyFrames=loadKeyFrames(dataSetPath,sessionID);
   

    estimatedPlanes=loadExtractedPlanes(dataSetPath,sessionID,keyFrames,PCpath, tresholdsV);
for i=1:length(keyFrames)
    frameID=keyFrames(i);
    [xzPlanes, xyPlanes, zyPlanes] =extractTypes(estimatedPlanes,...
            estimatedPlanes.(['fr' num2str(frameID)]).acceptedPlanes); 
        switch planeType
            case 0
                estimatedPlanesID{i} = xzPlanes;
            case 1
                estimatedPlanesID{i} = xyPlanes;
            case 2
                estimatedPlanesID{i} = zyPlanes;
        end
end

% i=2;
% figure,
% myPlotPlanes_v2(myPlanes{i},estimatedPlanesID{i})
% title (['boxes detected in sessionID/frame ' num2str(sessionID) '/' num2str(keyFrames(i))])

%% merge the two frames into a global frame
% --------Assumptions k=5 corresponds with global plane
% k=25 corresponds with local plane

globalPlanesIDs=estimatedPlanesID{1};
localPlanesIDS=estimatedPlanesID{2};

% convert IDs to vector of datum
globalPlanes=loadPlanesFromIDs(estimatedPlanes,globalPlanesIDs);
localPlanes=loadPlanesFromIDs(estimatedPlanes,localPlanesIDS);

%  merge
nglobalPlanes = mergeIntoGlobalPlanes(localPlanes,globalPlanes, tao, theta);
globalIDs=extractIDsFromVector(nglobalPlanes);

% figure,
% myPlotPlanes_v2(nglobalPlanes, globalIDs)


% plot global planes
figure,
myPlotPlanes_v2(estimatedPlanes,globalPlanesIDs)
view([0 0])
% camup([0 1 0])
title('global Planes')

% plot local planes
figure,
myPlotPlanes_v2(estimatedPlanes,localPlanesIDS)
view([0 0])
% camup([0 1 0])
title('local planes')

% plot new global planes
figure,
Nplanes=size(globalIDs,1);
for i=1:Nplanes
    frame_tp=globalIDs(i,1);
    element_tp=globalIDs(i,2);
    myPlotSinglePlane_v3(nglobalPlanes(i),frame_tp, 0)
end
view([0 0])
% camup([0 1 0])
xlabel 'x (m)'
ylabel 'y (m)'
zlabel 'z (m)'
title ('new global planes')



