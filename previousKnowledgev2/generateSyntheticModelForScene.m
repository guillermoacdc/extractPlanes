function [pcmodel, planeDescriptor_gt, Nboxes] = generateSyntheticModelForScene(rootPath, ...
    scene,spatialSampling,numberOfSides,groundFlag,idxBoxes,frameHL2)
%GENERATESYNTHETICMODELFORSCENE Summary of this function goes here
% inputs
% rootPath, path to the packing dataset
% scene, number of the scene
% spatialSampling, distance between two adjacent points in mm
% numberOfSides, {1: box with one side (top plane); 2: box with two sides, ...}
% groundFlag: {true: reconstruct the ground; false: do not reconstruct the ground}
% idxBoxes. index of target boxes in the physical packin sequence of the
% scene; do not confuse with box ids

% load previous knowledge in form of plane objects
% planeDescriptor_gt = convertPK2PlaneObjects(rootPath,scene);
planeDescriptor_gt = convertPK2PlaneObjects_v2(rootPath,scene,0,frameHL2);

Nboxes=size(planeDescriptor_gt.fr0.acceptedPlanes,1);
if nargin==5
    idxBoxes=1:Nboxes;
end

for i=1:Nboxes
    % load height
    H=loadLengths(rootPath,scene);
    H=H(i,4);
    % load depth and width for each box in scene
    L1=planeDescriptor_gt.fr0.values(i).L1;
    L2=planeDescriptor_gt.fr0.values(i).L2;
    pcTopPlane{i}=createSingleBoxPC_topSide(L1,L2,H,spatialSampling);
%     create the objects
    switch numberOfSides
        case 1
            %         create box with a single side (top side)
            pcBox{i}=createSingleBoxPC_topSide(L1,L2,H,spatialSampling);
            
        case 2
            %         create box with two sides. 
            pcBox{i}=createSingleBoxPC_twoSides(L1,L2,H,spatialSampling);
%             pcBox{i}=createSingleBoxPC_twoSides(L1,L2,H,spatialSampling);
        case 3
%             compute box with three sides. The opposite sides to point of
%             view are not included
            % compute angle btwn axis x (xm,xb)
            T=planeDescriptor_gt.fr0.values(i).tform;
            angle=computeAngleBtwnVectors([1 0 0]',T(1:3,1));
            if(T(2,1)<0)
                angle=-angle;
            end
    %         create box with three sides
            pcBox{i}=createSingleBoxPC_threeSides(L1,L2,H,spatialSampling, angle);
        otherwise
            disp('non defined value for number of sides')
    end
end
% project synthetic point clouds with its own Tform and merge points into a
% single vector
model=[];
modelTopPlane=[];

% for i=1:Nboxes
for i=1:length(idxBoxes)
    indexBox=idxBoxes(i);
%     indexBox=i;
    T=planeDescriptor_gt.fr0.values(indexBox).tform;
    pcBox_m=myProjection_v3(pcBox{indexBox},T);
    pcTopPlane_m=myProjection_v3(pcTopPlane{indexBox},T);
    model=[model; pcBox_m.Location];%merge points into a single vector
    modelTopPlane=[modelTopPlane; pcTopPlane_m.Location];
end
% remove points with z<0
model_z=model(:,3);
idx=find(model_z<0);
model(idx,:)=[];
% convert merged vector to a point cloud object
pcmodel=pointCloud(model);
if groundFlag

    % remove points of support in ground

    % create a synthetic ground plane
%     xmin=-2000;
%     xmax=2000;
%     ymin=-1000;
%     ymax=3000;
    xymax=max(modelTopPlane(:,[1,2]));
    xymin=min(modelTopPlane(:,[1,2]));
    xmax=xymax(1);
    ymax=xymax(2);
    xmin=xymin(1);
    ymin=xymin(2); 
    [~,groundPoints]=createSyntheticGround(xmax, xmin, ymax, ymin, spatialSampling);
    
    N=size(modelTopPlane,1);
    index=zeros(N,1);    
    for i=1:N
        target=modelTopPlane(i,[1,2]);
        idx = findNearestValueToTarget(target,groundPoints(:,[1,2]));
        index(i)=idx;
    end

    groundPoints(index,:)=[];
    pcGround=pointCloud(groundPoints);
    % fuse the ground with the model
    pcmodel=pcmerge(pcmodel,pcGround,spatialSampling);
end

end

