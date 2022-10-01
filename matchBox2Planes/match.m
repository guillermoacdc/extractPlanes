function [planeID,flag] = match(topPlanesEstimated_descriptors,planesEstimated,plane_gt,scene,rootPath)
%MATCH Find the match between a plane_gt and an element of the vector
%planesEstimated. Returns
% planeID
% flag of detection
% T. Transformation matrix of estimated plane projected to mocap world
%   Detailed explanation goes here

if isempty(topPlanesEstimated_descriptors)
    planeID=[];
    flag=0;
%     T_m=[];
    return
end

% load transformation matrix
Th2m=loadTh2m(rootPath,scene);%in mm
% load groundtruth data
geometricCenter_gt=plane_gt.geometricCenter;
% compute number of topl planes estimated
N=size(topPlanesEstimated_descriptors,1);

% project geometric center in estimated planes to mocap world
geometricCenter_estimated=zeros(N,3);
for i=1:N
    frame=topPlanesEstimated_descriptors(i,1);
    planeID=topPlanesEstimated_descriptors(i,2);

    gc_h=planesEstimated.(['fr' num2str(frame)]).values(planeID).geometricCenter*1000;%mm
    gc_m=Th2m*[gc_h 1]';
    geometricCenter_estimated(i,:)=gc_m(1:3);
end

% compute distance between features
for i=1:N
    distance(i)=norm(geometricCenter_estimated(i,:)-geometricCenter_gt);
end
[mindistance,indexmin]=min(distance);

if (mindistance>60)%threshold to detect a non-detected box in the scene
    planeID=[];
    flag=0;
%     T_m=[];
else
    planeID=topPlanesEstimated_descriptors(indexmin,2);
    flag=1;
%     T_m=Tplane(indexmin,:);
end


% % plot features 
% % generate the ground truth plane
% idBox=plane_gt.idBox;
% H=loadLengths(rootPath,scene);
% index=find(H(:,1)==idBox);
% H=H(index,4);
% spatialSampling=10;
% pc_gt=createSingleBoxPC_v2(plane_gt.L1,plane_gt.L2,H,spatialSampling);
% pc_gt=myProjection_v3(pc_gt,plane_gt.tform);
% 
% % load raw point cloud
% frame=topPlanesEstimated_descriptors(1,1);
% pc_mm=loadSLAMoutput(scene,frame,rootPath); 
% pc_m=myProjection_v3(pc_mm,Th2m);
% 
% figure,
% pcshow(pc_gt)
% hold on
% pcshow(pc_m)
% % project candidates to mocap world
% 
% for i=1:N
%     frame=topPlanesEstimated_descriptors(i,1);
%     planeID=topPlanesEstimated_descriptors(i,2);
%     T=planesEstimated.(['fr' num2str(frame)]).values(planeID).tform;
%     T(1:3,4)=T(1:3,4)*1000;
%     T1=Th2m*T;
%     dibujarsistemaref(T1,planeID,150,2,10,'w');
% end
% dibujarsistemaref(eye(4),'m',150,2,10,'w');
% 


end

