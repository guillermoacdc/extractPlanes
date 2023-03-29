function [matchIDs, eADD_m, estimatedPlanes_m, derivedMetrics]= poseMatching_v2(sessionID, frameID, ...
    estimatedPlanes,estimatedPlanesID, ...
    gtPoses,tao,theta,spatialSampling,dataSetPath, evalPath)
%POSEMATCHING 	An estimated pose  P ̂  is considered matchable with a 
% groundtruth pose P ̅, if it satisfies the necessary matching condition: 
% e_(ADD_pc ) (P ̅,P ̂,M,s)<θ_e, 
% where θ_e is a threshold of correctness ([.] is the Iverson bracket).

% e_(〖ADD〗_pc )=1/N ∑_(p=1…N)▒[|S ̅(p)-S ̂(p)|<τ] 
% s is the spatial sampling
% N: number of points of the point cloud generated from model M and with spatial sampling s
% S ̅(p) is the projection of the point p∈M with the pose P ̅
% S ̂(p) is the projection of the point p∈M with the pose P ̂

% matchIDs: [estimatedPlaneID boxID]; for boxID 0, it means that didnt
% matched with any ground truth


cameraPose=estimatedPlanes.(['fr' num2str(frameID)]).cameraPose;
pps=getPPS(dataSetPath,sessionID);
counterDetections=[pps zeros(length(pps),1)];%boxID, DetectedPlanes(DP) 
Nep=size(estimatedPlanesID,1);%Number of estimated planes
Ngtp=size(gtPoses,1);%number of ground truth planes
eADD_m=ones(Nep,Ngtp);%maximum error value is 1
matchIDs= zeros(Nep,2);

matchIDs(:,1)=estimatedPlanesID(:,2);
estimatedPlanesID_updated=estimatedPlanesID;

% project estimated poses of accepted planes to qm and convert length to mm
estimatedPlanes_m=myProjectionPlaneObject(estimatedPlanes,frameID,sessionID,dataSetPath);

for i=1:Ngtp
    boxID=gtPoses(i,1);
    gtPose=assemblyTmatrix(gtPoses(i,2:end));
%     Nep=size(estimatedPlanesID_updated,1);%Number of estimated planes; updated at each i-iteration
    for j=1:Nep
        estimatedPlaneID=estimatedPlanesID_updated(j,2);
        estimatedPlane=estimatedPlanes_m.(['fr' num2str(frameID)]).values(estimatedPlaneID);
        [er, et, eL1, eL2, eADD, n_inliers, dc, estimatedPose_m,L1gt,L2gt] = comparePlanes_v2(sessionID,...
            boxID, gtPose, estimatedPlane, spatialSampling,...
            dataSetPath,frameID, cameraPose, tao);
        eADD_m(i,j)=eADD;
        matchFlag=matchAssessmentPose_v2(eADD,theta,L1gt,L2gt);
        if matchFlag
            index=find(matchIDs(:,1)==estimatedPlaneID);
            matchIDs(index,2)=boxID;

            logtxt=['match in box ' num2str(boxID) ' with plane ID: '...
                num2str(frameID) '-' num2str(estimatedPlaneID) '   ' datestr(datetime)];
            disp(logtxt);
%             writeProcessingState(logtxt,evalPath,sessionID);
%             writeMainOutput(evalPath,sessionID,frameID,boxID,...
%                 estimatedPlaneID,estimatedPose_m,eADD,tao,theta);
%             writeAux1Output(evalPath,sessionID,frameID,boxID,...
%                 estimatedPlaneID,eL1,eL2,er,et,n_inliers,dc,tao,theta);
            counterDetections(i,2)=counterDetections(i,2)+1;
%             estimatedPlanesID_updated= setDiff_2D(estimatedPlanesID_updated,[frameID estimatedPlaneID]);%eliminate elements 2D
%             break;%to break the inner loop
        end
    end
end
derivedMetrics=computeDerivedMetrics(counterDetections);
% writeAux2Output(dataSetPath, evalPath,sessionID,frameID,derivedMetrics,...
%     Nep,tao,theta);
end

