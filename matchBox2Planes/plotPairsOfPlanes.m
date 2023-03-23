function plotPairsOfPlanes(EstimatedPlaneData,planeDescriptor_gt,...
    spatialSampling, boxID, dataSetPath)
%PLOTPAIRSOFPLANES Plot a pair of planes: (1) ground truth, (2) estimated
%   Detailed explanation goes here
% EstimatedPlaneData: frameID,boxID,estimatedPlaneID,Restimated_1...9,testimated_1...3,eADD

%% create point cloud of the top-plane associated with box id
    % load height
    lengthKnowledge = getPreviousKnowledge(dataSetPath,boxID);
    H=lengthKnowledge(3)*10;%mm
    pcTopPlane=createSingleBoxPC_topSide(planeDescriptor_gt.L1,...
        planeDescriptor_gt.L2,H,spatialSampling);
%% project plane to gt pose (pc_gt)
Tgt=planeDescriptor_gt.tform;
pc_gt=myProjection_v3(pcTopPlane,Tgt);
%% project plane to estimated pose (pc_e)
EstimatedPlaneData_a=table2array(EstimatedPlaneData);
Te=assemblyTmatrix([EstimatedPlaneData_a(1,4:6) EstimatedPlaneData_a(1,13) ...
    EstimatedPlaneData_a(1,7:9) EstimatedPlaneData_a(1,14) ...
    EstimatedPlaneData_a(1,10:12) EstimatedPlaneData_a(1,15)]);
pc_e=myProjection_v3(pcTopPlane,Te);

eADD=EstimatedPlaneData_a(1,16);
figure,
pcshow(pc_gt)
hold on
dibujarsistemaref(Tgt,'gt',150,2,10,'w');
pcshow(pc_e)
dibujarsistemaref(Te,'e',150,2,10,'w');
% dibujarsistemaref(eye(4),'m',150,2,10,'w');
xlabel 'x'
ylabel 'y'
zlabel 'z'
title (['top plane of box ' num2str(boxID) '. eADD=' num2str(eADD)...
    '. L_1/L_2= ' num2str(planeDescriptor_gt.L1) '/' num2str(planeDescriptor_gt.L2)])

end

