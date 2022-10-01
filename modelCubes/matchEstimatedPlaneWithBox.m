clc
close all
clear


scene=3;
frame=130;
keyBoxID=17;

% scene=5;%
% frame=25;

% scene=6;
% frame=66;

% scene=21;
% frame=6;

% scene=51;
% frame=29;

rootPath="C:\lib\boxTrackinPCs\";

%% load previous knowledge in form of plane objects
frame_gt=0;
planeDescriptor_gt = convertPK2PlaneObjects(rootPath,scene);
figure,
hold on
for i=1:size(planeDescriptor_gt.fr0.acceptedPlanes,1)
    tform_gt=planeDescriptor_gt.fr0.values(i).tform;
    planeID=planeDescriptor_gt.fr0.values(i).getID;
    myPlotPlaneContourPerpend(planeDescriptor_gt.fr0.values(i))
    dibujarsistemaref(tform_gt,planeID,150,1,10,'black')%(T,ind,scale,width,fs,fc)
end
    dibujarsistemaref(eye(4),'m',1000,1,10,'black')%(T,ind,scale,width,fs,fc)
    grid on 
    xlabel x
    ylabel y
    zlabel z
title (['Boxes distribution in scene ' num2str(scene)])

% extract top planes (xzPlanes) from accepted planes
xzPlanes=planeDescriptor_gt.(['fr' num2str(frame_gt)]).acceptedPlanes;

% set neighborhoods in estimated planes
N=size(xzPlanes,1);
for i=1:N
    targetPlane=xzPlanes(i,:);
    searchSpace=xzPlanes;
    searchSpace(i,:)=[];
%     modification of first and second neighborhod in planeDescriptor
%     vector. Pass by reference
    computeNeighborhoodPlanes(targetPlane,searchSpace,planeDescriptor_gt);
end

% extract plane associated with keyBoxID (plane_gt), with all its properties
for i=1:size(planeDescriptor_gt.fr0.acceptedPlanes,1)
    if planeDescriptor_gt.fr0.values(i).idBox==keyBoxID
        plane_gt=planeDescriptor_gt.fr0.values(i);
    end
end



%% compute estimated planes in the scene
planesEstimated=detectPlanes(rootPath,scene,frame);
figure,
myPlotPlanes_v2(planesEstimated,planesEstimated.(['fr' num2str(frame)]).acceptedPlanes)
title (['boxes detected in scene/frame ' num2str(scene) '/' num2str(frame)])


% extract top planes (xzPlanes) from accepted planes
acceptedPlanes=planesEstimated.(['fr' num2str(frame)]).acceptedPlanes;
xzPlanes_e=extractTypes(planesEstimated, acceptedPlanes);
% set neighborhoods in estimated planes
N_estimatedPlanes=size(xzPlanes_e,1);
for i=1:N_estimatedPlanes
    targetPlane=xzPlanes_e(i,:);
    searchSpace=xzPlanes_e;
    searchSpace(i,:)=[];
%     modification of first and second neighborhod in planesEstimated
%     vector. Pass by reference
    computeNeighborhoodPlanes(targetPlane,searchSpace,planesEstimated);
end


%% match single groundtruth with estimated pose
% warning. groundtruth length in mm but estimated pose in meters

% convert estimated lengths to mm
estimatedLengths=zeros(N_estimatedPlanes,5);%planeID L1mm L2mm d_nearestBox
for i=1:N_estimatedPlanes
    planeID=planesEstimated.(['fr' num2str(xzPlanes_e(i,1))]).values(xzPlanes_e(i,2)).idPlane;
    L1mm=planesEstimated.(['fr' num2str(xzPlanes_e(i,1))]).values(xzPlanes_e(i,2)).L1*1000;
    L2mm=planesEstimated.(['fr' num2str(xzPlanes_e(i,1))]).values(xzPlanes_e(i,2)).L2*1000;
    gc1=planesEstimated.(['fr' num2str(xzPlanes_e(i,1))]).values(xzPlanes_e(i,2)).geometricCenter*1000;
%     distance to nearest plane
    npID=planesEstimated.(['fr' num2str(xzPlanes_e(i,1))]).values(xzPlanes_e(i,2)).nearestPlaneID;
    gc2=planesEstimated.(['fr' num2str(npID(1))]).values(npID(2)).geometricCenter*1000;
    np_vector=gc1-gc2;
    d_nearestBox=norm(np_vector);
%     distance to second nearest plane
    npID=planesEstimated.(['fr' num2str(xzPlanes_e(i,1))]).values(xzPlanes_e(i,2)).secondNearestPlaneID;
    gc2=planesEstimated.(['fr' num2str(npID(1))]).values(npID(2)).geometricCenter*1000;
    np_vector=gc1-gc2;
    d_secondNearestBox=norm(np_vector);
    

    estimatedLengths(i,:)=[planeID L1mm L2mm d_nearestBox d_secondNearestBox];
end
% sort gt data
npID=plane_gt.nearestPlaneID;
np_vector=plane_gt.geometricCenter-planeDescriptor_gt.(['fr' num2str(npID(1))]).values(npID(2)).geometricCenter;
d_nearestBox=norm(np_vector);

npID=plane_gt.secondNearestPlaneID;
np_vector=plane_gt.geometricCenter-planeDescriptor_gt.(['fr' num2str(npID(1))]).values(npID(2)).geometricCenter;
d_secondNearestBox=norm(np_vector);


gtLengths=[keyBoxID, plane_gt.L1, plane_gt.L2 d_nearestBox d_secondNearestBox];


% compute distance between reference and estimated features
for i=1:N_estimatedPlanes
    distanceFeat(i)=norm(gtLengths(2:5)-estimatedLengths(i,2:5));
end
% compute minimum index
[~,indexmin]=min(distanceFeat);
matchedPlane=estimatedLengths(indexmin,1);

distanceFeat(indexmin)=[];
[~,indexmin]=min(distanceFeat);
matchedPlane2=estimatedLengths(indexmin,1);

% plot features L1, L2 between estimated planes and groundTruth
figure,
plot(estimatedLengths(:,[2]),estimatedLengths(:,[3]),'bo')
text(estimatedLengths(:,[2]),estimatedLengths(:,[3]),num2str(estimatedLengths(:,[1])))
hold on
plot(gtLengths(:,[2]),gtLengths(:,[3]),'rs')
text(gtLengths(:,[2]),gtLengths(:,[3]),['box_{' num2str(keyBoxID) '}'])
xlabel 'L1'
ylabel 'L2'
title 'features between estimated planes and ground truth'
grid on


% plot features L1, L2, distanceToNearest Plane between estimated planes and groundTruth
figure,
plot3(estimatedLengths(:,[2]),estimatedLengths(:,[3]),estimatedLengths(:,[4]),'bo')
text(estimatedLengths(:,[2]),estimatedLengths(:,[3]),estimatedLengths(:,[4]),num2str(estimatedLengths(:,[1])))
hold on
plot3(gtLengths(:,[2]),gtLengths(:,[3]),gtLengths(:,[4]),'rs')
text(gtLengths(:,[2]),gtLengths(:,[3]),gtLengths(:,[4]),['box_{' num2str(keyBoxID) '}'])
xlabel 'L1'
ylabel 'L2'
zlabel 'd to nearest box'
title (['features between estimated and ground truth. Matched id:' num2str(matchedPlane)])
grid on