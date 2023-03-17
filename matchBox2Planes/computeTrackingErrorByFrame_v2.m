function  computeTrackingErrorByFrame_v2(evalPath, datasetPath, gtPose,...
    estimatedPlanes, planesID, scene, frame, spatialSampling, th_vector)
%COMPUTETRACKINGERRORBYFRAME Summary of this function goes here
%   Detailed explanation goes here
% _v2 implements strategies to reduce computational complexity in the match
% search between estimated and ground truth planes


tao=th_vector(2);
pps=getPPS(datasetPath,scene);
counterDetections=[pps zeros(length(pps),1)];%boxID, DetectedPlanes(DP) 
M=size(gtPose,1);%number of ground truth planes
% N=size(planesID,1);%number of estimated planes

planesID_updated=planesID;%initialization
cameraPose=estimatedPlanes.(['fr' num2str(frame)]).cameraPose;
for i=1:M
    boxID=gtPose(i,1);
    gtPlanePose=assemblyTmatrix(gtPose(i,2:end));
    N=size(planesID_updated,1);%number of estimated planes
    for j=1:N
        planeID=planesID_updated(j,2);
        detectedPlane=estimatedPlanes.(['fr' num2str(frame)]).values(planeID);

        [er, et, eL1, eL2, eADD, n_inliers, dc] = comparePlanes(scene,...
            boxID, gtPlanePose, detectedPlane, spatialSampling,...
            datasetPath,frame, cameraPose, tao);

        matchFlag=matchAssessmentPose(er, et, eADD, th_vector);
        if matchFlag
            display(['match in box ' num2str(boxID) ' with plane ID: ' num2str(frame) '-' num2str(planeID) '   ' datestr(datetime)])
            counterDetections(i,2)=counterDetections(i,2)+1;
            writeLogBasis_csv(er, et, eL1, eL2, eADD, n_inliers, dc, boxID, evalPath, frame, scene, planeID);
            planesID_updated= setDiff_2D(planesID_updated,[frame planeID]);%eliminate elements 2D
            break;%to break the inner loop
        end
    end
end
derivedMetrics=computeDerivedMetrics(counterDetections);
writeLogDerived_csv(datasetPath, evalPath,scene,frame,derivedMetrics,size(planesID,1));

end

