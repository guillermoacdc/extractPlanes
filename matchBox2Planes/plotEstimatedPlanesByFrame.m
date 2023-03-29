function T=plotEstimatedPlanesByFrame(dataSetPath,sessionID,frameID,...
    processedPlanesPath,tresholdsV, planeType,tao,theta,spatialSampling, evalPath)
%PLOTESTIMATEDPLANESBYFRAME Plots the estimated planes wrt gt planes and
%displays an error function for each estimation
%   Detailed explanation goes here

gtPoses=loadInitialPose(dataSetPath,sessionID,frameID);
estimatedPlanes=loadExtractedPlanes(dataSetPath,sessionID,frameID,...
    processedPlanesPath,tresholdsV);


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
[matchIDs, eADD_m, estimatedPlanes_m, derivedMetrics]= poseMatching_v2(sessionID, frameID, ...
    estimatedPlanes,estimatedPlanesID,...
    gtPoses,tao,theta,spatialSampling,dataSetPath, evalPath);
Ne=size(estimatedPlanesID,1);
% pps=getPPS(dataSetPath,sessionID);
for i=1:Ne
        boxID=matchIDs(i,2);
        estimatedPlaneID=matchIDs(i,1);
        estimatedPlane=estimatedPlanes_m.(['fr' num2str(frameID)]).values(estimatedPlaneID);
        plotEstimatedPlaneVsAllGtPlanes(estimatedPlane,dataSetPath,sessionID,eADD_m(:,i),spatialSampling,boxID);
end

boxByFrameA = loadBoxByFrame(dataSetPath,sessionID);
extractedBoxes=computeIndexesBeforeFrame(boxByFrameA(:,3), frameID)-1;%number of extracted boxes from consolidation zone at an specific frame
DP=sum(derivedMetrics(:,2));
MD=sum(derivedMetrics(:,3));
MP=sum(derivedMetrics(:,4))-extractedBoxes;
SP=size(gtPoses,1)-DP;
T=table(frameID, DP, MD, MP, SP);

end

