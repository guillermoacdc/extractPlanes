function poseMatching(sessionID, frameID, estimatedPlanes,planeType,...
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


% estimatedPlanesID=estimatedPlanes.(['fr' num2str(frameID)]).acceptedPlanes;
%     compute estimated planesID based on the planeType
    [xzPlanes, xyPlanes, zyPlanes] =extractTypes(estimatedPlanes,...
        estimatedPlanes.(['fr' num2str(frameID)]).acceptedPlanes); 
    switch planeType
        case 0
            estimatedPlanesID = xzPlanes;
        case 1
            estimatedPlanesID = xyPlanes;
        case 2
            estimatedPlanesID = zyPlanes;
    end

cameraPose=estimatedPlanes.(['fr' num2str(frameID)]).cameraPose;
pps=getPPS(dataSetPath,sessionID);
counterDetections=[pps zeros(length(pps),1)];%boxID, DetectedPlanes(DP) 

Ngtp=size(gtPoses,1);%number of ground truth planes

estimatedPlanesID_updated=estimatedPlanesID;
for i=1:Ngtp
    boxID=gtPoses(i,1);
    gtPose=assemblyTmatrix(gtPoses(i,2:end));
    Nep=size(estimatedPlanesID_updated,1);%Number of estimated planes; updated at each i-iteration
    for j=1:Nep
        estimatedPlaneID=estimatedPlanesID_updated(j,2);
        estimatedPlane=estimatedPlanes.(['fr' num2str(frameID)]).values(estimatedPlaneID);
        [er, et, eL1, eL2, eADD, n_inliers, dc, estimatedPose_m] = comparePlanes(sessionID,...
            boxID, gtPose, estimatedPlane, spatialSampling,...
            dataSetPath,frameID, cameraPose, tao);
        matchFlag=matchAssessmentPose_v2(eADD,theta);
        if matchFlag
            display(['match in box ' num2str(boxID) ' with plane ID: ' num2str(frameID) '-' num2str(estimatedPlaneID) '   ' datestr(datetime)])
            writeMainOutput(evalPath,sessionID,frameID,boxID,...
                estimatedPlaneID,estimatedPose_m,eADD,tao,theta);
            writeAux1Output(evalPath,sessionID,frameID,boxID,...
                estimatedPlaneID,eL1,eL2,er,et,n_inliers,dc,tao,theta);
            counterDetections(i,2)=counterDetections(i,2)+1;
            estimatedPlanesID_updated= setDiff_2D(estimatedPlanesID_updated,[frameID estimatedPlaneID]);%eliminate elements 2D
            break;%to break the inner loop
        end
    end
end
derivedMetrics=computeDerivedMetrics(counterDetections);
writeAux2Output(dataSetPath, evalPath,sessionID,frameID,derivedMetrics,...
    size(estimatedPlanesID,1),tao,theta);
end

