function computePoseErrorByScene(scene, datasetPath, evalPath,...
    detectionsPath, spatialSampling,planeType, th_vector)
%COMPUTEPOSEERRORBYSCENE Summary of this function goes here
%   Detailed explanation goes here
keyframes=loadKeyFrames(datasetPath,scene);
N=length(keyframes);
for i=1:N
% for i=66:N  %test to begin in frame 71 - scene3
    frame=keyframes(i);
    display(['Processing Frame ' num2str(frame) '     ' datestr(datetime)])
    gtPose=loadInitialPose(datasetPath,scene,frame);
    estimatedPlanes=detectPlanes(datasetPath,scene,frame,detectionsPath);
%     compute estimated planesID based on the planeType
    [xzPlanes, xyPlanes, zyPlanes] =extractTypes(estimatedPlanes,...
        estimatedPlanes.(['fr' num2str(frame)]).acceptedPlanes); 
    switch planeType
        case 0
            planesID = xzPlanes;
        case 1
            planesID = xyPlanes;
        case 2
            planesID = zyPlanes;
    end

%     computeTrackingErrorByFrame(evalPath, datasetPath, gtPose,...
%         estimatedPlanes, planesID, scene, frame, spatialSampling, th_vector);
computeTrackingErrorByFrame_v2(evalPath, datasetPath, gtPose,...
        estimatedPlanes, planesID, scene, frame, spatialSampling, th_vector);
end

end

