% 

clc
close all
clear


scene=3;
frame=6;
keyBoxID=14;

% scene=5;%
% frame=5;
% keyBoxID=15;

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
N_gtPlanes=size(xzPlanes,1);
for i=1:N_gtPlanes
    targetPlane=xzPlanes(i,:);
    searchSpace=xzPlanes;
    searchSpace(i,:)=[];
%     modification of first and second neighborhod in planeDescriptor
%     vector. Pass by reference
    computeNeighborhoodPlanes(targetPlane,searchSpace,planeDescriptor_gt);
end

% extract plane associated with keyBoxID (plane_gt), with all its properties
for i=1:N_gtPlanes
    if planeDescriptor_gt.fr0.values(i).idBox==keyBoxID
        plane_gt=planeDescriptor_gt.fr0.values(i);
    end
end

% extract previous knowledge on L1, L2 lengths
for i=1:N_gtPlanes
    L1_pk(i)=planeDescriptor_gt.fr0.values(i).L1;
    L2_pk(i)=planeDescriptor_gt.fr0.values(i).L2;
end
L1_pk=unique(L1_pk);
L2_pk=unique(L2_pk);



%% compute estimated planes in the scene
planesEstimated=detectPlanes(rootPath,scene,frame);
figure,
myPlotPlanes_v2(planesEstimated,planesEstimated.(['fr' num2str(frame)]).acceptedPlanes)
title (['boxes detected in scene/frame ' num2str(scene) '/' num2str(frame)])


% extract top planes (xzPlanes) from accepted planes
acceptedPlanes=planesEstimated.(['fr' num2str(frame)]).acceptedPlanes;
xzPlanes_e=extractTypes(planesEstimated, acceptedPlanes);
N_estimatedPlanes=size(xzPlanes_e,1);
% compute distance to camera for each candidate
for i=1:N_estimatedPlanes
    planeID=planesEstimated.(['fr' num2str(xzPlanes_e(i,1))]).values(xzPlanes_e(i,2)).idPlane;
    dcamera(i)=computeDistanceToCamera(planesEstimated,[frame planeID]);
end
% normalize dcamera
dcamera=dcamera/min(dcamera);

% set neighborhoods in estimated planes

for i=1:N_estimatedPlanes
    targetPlane=xzPlanes_e(i,:);
    searchSpace=xzPlanes_e;
    searchSpace(i,:)=[];
%     modification of first and second neighborhod in planesEstimated
%     vector. Pass by reference
    closestDistance(i)=computeNeighborhoodPlanes(targetPlane,searchSpace,planesEstimated);
end
maxdBtwnNearestBoxes=max(closestDistance)*1000;

%% match single groundtruth with estimated pose
% warning. groundtruth length in mm but estimated pose in meters

% convert estimated lengths to mm
estimatedFeatures=zeros(N_estimatedPlanes,6);%planeID L1mm L2mm d_nearestBox anglbtwnL1
for i=1:N_estimatedPlanes
    outsideOpRange=false;
    planeID=planesEstimated.(['fr' num2str(xzPlanes_e(i,1))]).values(xzPlanes_e(i,2)).idPlane;
% compute distance to camera
%     dcamera=computeDistanceToCamera(planesEstimated,[frame planeID]);
%     if planeID==16
%         disp('stop')
%     end
%     if dcamera>3 | dcamera<0.5
%         outsideOpRange=true;
%     end

    L1mm=planesEstimated.(['fr' num2str(xzPlanes_e(i,1))]).values(xzPlanes_e(i,2)).L1*1000;
    L2mm=planesEstimated.(['fr' num2str(xzPlanes_e(i,1))]).values(xzPlanes_e(i,2)).L2*1000;
% round L1 and L2 based on previous knowledge. Round L1mm to the nearest
% integer in L1_pk, greater than L1mm
    L1mm=roundCeil(L1mm,L1_pk);
    L2mm=roundCeil(L2mm,L2_pk);
%     normalize Lengths
    L1mm=L1mm/max(L1_pk);
    L2mm=L2mm/max(L2_pk);

%     closestIndex=computeClosestIndex(L1_pk,L1mm);
%     L1mm=L1_pk(closestIndex);
%     closestIndex=computeClosestIndex(L2_pk,L2mm);
%     L2mm=L2_pk(closestIndex);

    gc1=planesEstimated.(['fr' num2str(xzPlanes_e(i,1))]).values(xzPlanes_e(i,2)).geometricCenter*1000;
    tform1=planesEstimated.(['fr' num2str(xzPlanes_e(i,1))]).values(xzPlanes_e(i,2)).tform;
    L1_vector=tform1(1:3,1);
%     distance to nearest plane
    npID=planesEstimated.(['fr' num2str(xzPlanes_e(i,1))]).values(xzPlanes_e(i,2)).nearestPlaneID;
    gc2=planesEstimated.(['fr' num2str(npID(1))]).values(npID(2)).geometricCenter*1000;
    np_vector=gc1-gc2;
    d_nearestBox=norm(np_vector);
% normalize distance to nearest box
    d_nearestBox=d_nearestBox/maxdBtwnNearestBoxes;
% rotation error wrt nearest plane
    nptform=planesEstimated.(['fr' num2str(npID(1))]).values(npID(2)).tform;
    [~,er]=computeSinglePoseError(nptform,tform1);
%     normalize er
    er=er/180;
%     distance to second nearest plane
    npID=planesEstimated.(['fr' num2str(xzPlanes_e(i,1))]).values(xzPlanes_e(i,2)).secondNearestPlaneID;
    gc2=planesEstimated.(['fr' num2str(npID(1))]).values(npID(2)).geometricCenter*1000;
    np_vector=gc1-gc2;
    d_secondNearestBox=norm(np_vector);

%     if outsideOpRange
%         estimatedFeatures(i,:)=[planeID L1mm*0 L2mm*0 d_nearestBox d_secondNearestBox er];
%     else
%         estimatedFeatures(i,:)=[planeID L1mm/dcamera(i) L2mm/dcamera(i) d_nearestBox/dcamera(i) d_secondNearestBox er];
%     end
 
estimatedFeatures(i,:)=[planeID L1mm L2mm d_nearestBox/dcamera(i) d_secondNearestBox er];
end



% sort gt data
% compute distance to nearest box
    npID=plane_gt.nearestPlaneID;
    np_vector=plane_gt.geometricCenter-planeDescriptor_gt.(['fr' num2str(npID(1))]).values(npID(2)).geometricCenter;
    d_nearestBox=norm(np_vector);
% normalize distance to nearest box
    d_nearestBox=d_nearestBox/maxdBtwnNearestBoxes;

% compute distance to second nearest box
    npID=plane_gt.secondNearestPlaneID;
    np_vector=plane_gt.geometricCenter-planeDescriptor_gt.(['fr' num2str(npID(1))]).values(npID(2)).geometricCenter;
    d_secondNearestBox=norm(np_vector);
% compute rotation error wrt nearest plane
    nptform=planeDescriptor_gt.(['fr' num2str(npID(1))]).values(npID(2)).tform;

[~,er]=computeSinglePoseError(nptform,plane_gt.tform);
%     normalize er
er=er/180;

%     normalize Lengths
gt_features=[keyBoxID, plane_gt.L1/max(L1_pk), plane_gt.L2/max(L2_pk) d_nearestBox d_secondNearestBox er];


%% compute distance between reference and estimated features

gt_features3D=gt_features(1,[2,3,4]);
estimatedFeatures3D=estimatedFeatures(:,[2,3,4]);
% compute a derive feature
% gt_features3D(3)=mean([gt_features(1,4),gt_features(1,6)],2);
% estimatedFeatures3D(:,3)=mean([estimatedFeatures(:,4),estimatedFeatures(:,6)],2);
% s1=0.5;
% gt_features3D(3)=(s1*gt_features(1,4) + (1-s1)*gt_features(1,6))/2;
% estimatedFeatures3D(:,3)=(s1*estimatedFeatures(:,4) + (1-s1)*estimatedFeatures(:,6))/2;


for i=1:N_estimatedPlanes
    distanceFeat(i)=norm(gt_features3D-estimatedFeatures3D(i,:));    
%     distanceFeat(i)=norm(gt_features(1,[2,3,6])-estimatedFeatures(i,[2,3,6]));    
%     distanceFeat(i)=norm(gt_features(2:4)-estimatedFeatures(i,2:4));
%     distanceFeat(i)=norm(gt_features(2:5)-estimatedFeatures(i,2:5));
end
% compute minimum index
[~,indexmin]=min(distanceFeat);
matchedPlane=estimatedFeatures(indexmin,1);

distanceFeat(indexmin)=[];
[~,indexmin]=min(distanceFeat);
matchedPlane2=estimatedFeatures(indexmin,1);

% plot features L1, L2 between estimated planes and groundTruth
figure,
plot(estimatedFeatures(:,[2]),estimatedFeatures(:,[3]),'bo')
text(estimatedFeatures(:,[2]),estimatedFeatures(:,[3]),num2str(estimatedFeatures(:,[1])))
hold on
plot(gt_features(:,[2]),gt_features(:,[3]),'rs')
text(gt_features(:,[2]),gt_features(:,[3]),['box_{' num2str(keyBoxID) '}'])
xlabel 'L1'
ylabel 'L2'
title 'features between estimated planes and ground truth'
grid on


% plot features L1, L2, distanceToNearest Plane between estimated planes and groundTruth
figure,
plot3(estimatedFeatures3D(:,[1]),estimatedFeatures3D(:,[2]),estimatedFeatures3D(:,[3]),'bo')
text(estimatedFeatures3D(:,[1]),estimatedFeatures3D(:,[2]),estimatedFeatures3D(:,[3]),num2str(estimatedFeatures(:,[1])))
hold on
plot3(gt_features3D(:,1),gt_features3D(:,2),gt_features3D(:,3),'rs')
text(gt_features3D(:,1),gt_features3D(:,2),gt_features3D(:,3),['box_{' num2str(keyBoxID) '}'])
xlabel 'L1'
ylabel 'L2'
zlabel 'ponderated distance to closest box'
title (['features between estimated and ground truth. Matched id:' num2str(matchedPlane)])
grid on


% figure,
% plot3(estimatedFeatures(:,[2]),estimatedFeatures(:,[3]),estimatedFeatures(:,[6]),'bo')
% text(estimatedFeatures(:,[2]),estimatedFeatures(:,[3]),estimatedFeatures(:,[6]),num2str(estimatedFeatures(:,[1])))
% hold on
% plot3(gt_features(:,[2]),gt_features(:,[3]),gt_features(:,[6]),'rs')
% text(gt_features(:,[2]),gt_features(:,[3]),gt_features(:,[6]),['box_{' num2str(keyBoxID) '}'])
% xlabel 'L1'
% ylabel 'L2'
% zlabel 'e_r wrt nearest box/plane'
% title (['features between estimated and ground truth. Matched id:' num2str(matchedPlane)])
% grid on