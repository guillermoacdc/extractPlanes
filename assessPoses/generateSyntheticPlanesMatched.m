function [pc_e, pc_gt, Te, T_gt, eADD]=generateSyntheticPlanesMatched(sessionID,boxID, frameID,...
    planeID, planeType, NpointsDiagTopSide, numberOfSides, tao, fileName, dataSetPath, evalPath)
%PLOTSYNTHETICPLANESMATCHED Summary of this function goes here
%   Detailed explanation goes here

% Te=loadEstimatedPose(sessionID, frameID, planeID, evalPath);
estimatedPoses = loadEstimationsFile(fileName,sessionID, evalPath);
planeIDs=estimatedPoses.(['frame' num2str(frameID)]).IDObjects;
indexPlaneID=find(planeIDs==planeID);
Te_a=estimatedPoses.(['frame' num2str(frameID)]).poses(indexPlaneID,:);
Te=assemblyTmatrix(Te_a);
pps=getPPS(dataSetPath,sessionID,frameID);
indexBoxID=find(pps==boxID);
% eADD=estimatedPoses.(['frame' num2str(frameID)]).eADD.tao50(indexPlaneID, indexBoxID);%update with variable tao
eADD=estimatedPoses.(['frame' num2str(frameID)]).eADD.(['tao' num2str(tao)])(indexPlaneID, indexBoxID);%update with variable tao

planeObject_gt= convertPK2PlaneObjects_v3(dataSetPath,sessionID,planeType, frameID, boxID);

pc_cell=createSyntheticPC(planeObject_gt,NpointsDiagTopSide, numberOfSides);
pc=pc_cell{1};
% project pc to gt and estimated poses
pc_e=myProjection_v3(pc,Te);
T_gt=planeObject_gt.fr0.values.tform;
pc_gt=myProjection_v3(pc,T_gt);
% paint pcs

% color the ground truth point cloud with green color [0 1 0]
pointscolor=uint8(zeros(pc_gt.Count,3));
pointscolor(:,1)=0;
pointscolor(:,2)=255;
pointscolor(:,3)=0;
pc_gt.Color=pointscolor;
% color the estimated point cloud with white color [1 1 1]. For more colors visit: https://www.mathworks.com/help/matlab/creating_plots/specify-plot-colors.html
pointscolor=uint8(zeros(pc_e.Count,3));
pointscolor(:,1)=255;
pointscolor(:,2)=255;
pointscolor(:,3)=255;
pc_e.Color=pointscolor;
 
end

