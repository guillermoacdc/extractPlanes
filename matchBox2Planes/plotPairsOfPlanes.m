function plotPairsOfPlanes(EstimatedPlaneData,planeDescriptor_gt,...
    spatialSampling, boxID, dataSetPath)
%PLOTPAIRSOFPLANES Plot a pair of planes: (1) ground truth, (2) estimated
%   Detailed explanation goes here
% EstimatedPlaneData: frameID,boxID,estimatedPlaneID,Restimated_1...9,testimated_1...3,eADD

%% create point cloud of the top-plane associated with box id
d=sqrt(planeDescriptor_gt.L1^2+planeDescriptor_gt.L2^2);
spatialSampling=d/50;
    % load height
    lengthKnowledge = getPreviousKnowledge(dataSetPath,boxID);
    H=lengthKnowledge(3)*10;%mm
% top plane    
%     pcTopPlane=createSingleBoxPC_topSide(planeDescriptor_gt.L1,...
%         planeDescriptor_gt.L2,H,spatialSampling);
% two sides
%     pcTopPlane=createSingleBoxPC_twoSides(planeDescriptor_gt.L1,...
%         planeDescriptor_gt.L2,H,spatialSampling);
% three sides
            Tgt=planeDescriptor_gt.tform;
            angle=computeAngleBtwnVectors([1 0 0]',Tgt(1:3,1));
            if(Tgt(2,1)<0)
                angle=-angle;
            end
            
    %         create box with three sides
            pcTopPlane=createSingleBoxPC_threeSides(planeDescriptor_gt.L1,...
                planeDescriptor_gt.L2,H,spatialSampling, angle);

%% project plane to gt pose (pc_gt)
% Tgt=planeDescriptor_gt.tform;
pc_gt=myProjection_v3(pcTopPlane,Tgt);
% color the point cloud with green color [0 1 0]
pointscolor=uint8(zeros(pc_gt.Count,3));
pointscolor(:,1)=0;
pointscolor(:,2)=255;
pointscolor(:,3)=0;
pc_gt.Color=pointscolor;

%% project plane to estimated pose (pc_e)

EstimatedPlaneData_a=table2array(EstimatedPlaneData);
Te=assemblyTmatrix([EstimatedPlaneData_a(1,4:6) EstimatedPlaneData_a(1,13) ...
    EstimatedPlaneData_a(1,7:9) EstimatedPlaneData_a(1,14) ...
    EstimatedPlaneData_a(1,10:12) EstimatedPlaneData_a(1,15)]);
pc_e=myProjection_v3(pcTopPlane,Te);
% color the point cloud with white color [1 1 1]. See for more colors: https://www.mathworks.com/help/matlab/creating_plots/specify-plot-colors.html
pointscolor=uint8(zeros(pc_e.Count,3));
pointscolor(:,1)=255;
pointscolor(:,2)=255;
pointscolor(:,3)=255;
pc_e.Color=pointscolor;

eADD=EstimatedPlaneData_a(1,16);
figure,
pcshow(pc_gt,"MarkerSize",6)
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

