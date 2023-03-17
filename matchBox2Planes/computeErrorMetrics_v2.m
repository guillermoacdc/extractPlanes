function [erVector,etVector,el1,el2, p_detection]=computeErrorMetrics_v2(detectionByFrameObj,...
    detectionByFrameDescriptor,rootPath,scene,planeType,boxID)
%COMPUTEERRORMETRICS Computes multiple kind of errors between a detected
%plane and a gt plane
% 1. erVector. Rotation error with size (N,4). There implements four indicators
% a. rotation error as described in [1]
% b. roll or offset angle considering a rotation in x axis of reference
% c. pitch or offset angle considering a rotation in y axis of ref
% d. yaw or offset angle considering a rotation in z axis of ref
% 2. etVector> translation error with size (N,1)
% 3. Length L1 error with size (N,1)
% 4. Length L2 error with size (N,1)
% 5. percentage of detections between all keyframes with size (1,1)

%   Detailed explanation goes here

%% compute percent of keyframes where the box was detected
N=size(detectionByFrameDescriptor,1);
p_detection=sum(detectionByFrameDescriptor(:,3))/N*100;



%% extract keyframes and plane IDs, where detection was success
indexes=find(detectionByFrameDescriptor(:,3));
keyFrame_det=detectionByFrameDescriptor(indexes,1);
planeID_det=detectionByFrameDescriptor(indexes,2);

%load T from hololens 2 mocap
Th2m=loadTh2m(rootPath,scene);%in mm

N2=size(planeID_det,1);


etVector=zeros(N2,1);
erVector=zeros(N2,4);
el1=zeros(N2,1);
el2=zeros(N2,1);
Tcoordinates=eye(4);
Tcoordinates(1:3,1:3)=[0 1 0; 0 0 1; 1 0 0];
%% extract references of pose and length
[reposFlag,reposFrame] = isRepositioned(rootPath,scene,boxID);
% compute plane ground truth for frame 0
planesDescriptors_gt=convertPK2PlaneObjects_v2(rootPath,scene,planeType,0);
plane_gt=extractPlaneByBoxID(planesDescriptors_gt,boxID);
Tref=plane_gt.tform;
L1ref=plane_gt.L1;%mm
L2ref=plane_gt.L2;%mm

for i=1:N2
    frame=detectionByFrameObj(i).idFrame;
    if reposFlag & frame>reposFrame
%         update reference of pose
        planesDescriptors_gt=convertPK2PlaneObjects_v2(rootPath,scene,planeType,reposFrame);
        plane_gt=extractPlaneByBoxID(planesDescriptors_gt,boxID);
        Tref=plane_gt.tform;
        reposFlag=false;
    end
    Testimated_h=detectionByFrameObj(i).tform;
    Testimated_h(1:3,4)=Testimated_h(1:3,4)*1000;
    Testimated_m=Th2m*Testimated_h*Tcoordinates;
    L1estimated=detectionByFrameObj(i).L1*1000;%mm
    L2estimated=detectionByFrameObj(i).L2*1000;%mm
    [et, er, ~, alpha, beta, gamma]=computeSinglePoseError(Testimated_m,Tref);
    etVector(i)=et;
    erVector(i,1)=er;
    erVector(i,2)=alpha;
    erVector(i,3)=beta;
    erVector(i,4)=gamma;

    el1(i)=abs(L1estimated-L1ref);
    el2(i)=abs(L2estimated-L2ref);
end


% generate the ground truth plane
% idBox=plane_gt.idBox;
% H=loadLengths(rootPath,scene);
% index=find(H(:,1)==idBox);
% H=H(index,4);
% spatialSampling=10;
% pc_gt=createSingleBoxPC_v2(plane_gt.L1,plane_gt.L2,H,spatialSampling);
% pc_gt=myProjection_v3(pc_gt,plane_gt.tform);

% figure,
% pcshow(pc_gt)
% hold on
% dibujarsistemaref(eye(4),'m',150,2,10,'w');
% dibujarsistemaref(plane_gt.tform,idBox,150,2,10,'w');
% dibujarsistemaref(Testimated_m,planeID_det(end),150,2,10,'w');

end

