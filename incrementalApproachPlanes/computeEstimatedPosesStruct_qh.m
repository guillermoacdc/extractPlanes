function estimatedPoses=computeEstimatedPosesStruct_qh(globalPlanes_h,...
            frameID,estimatedPlanesID,estimatedPoses, ProcessingTime)
%COMPUTEESTIMATEDPOSESSTRUCT computes estimatedPoses struct. 

% 2. Computes the struct estimatePoses. This has the next fields by frame:
%     IDObjects: ID of the detected objects with size No
%         poses: pose of each object with size [No×16 double]
%            L1: length 1 of detected objects with size No
%            L2: length 2 of detected objects with size No
%      Ninliers: number of inliers for each detected object with size No
%            dc: distance btwn camera and object with size No
%ProcessingTime: x ms with size 1x1


%% Computes the struct estimatePoses
        estimatedPoses.(['frame' num2str(frameID)]).IDObjects=estimatedPlanesID;
        [poses, L1e, L2e, ~, fitness]=convertToArrays_v2(globalPlanes_h);
        estimatedPoses.(['frame' num2str(frameID)]).poses=poses;
        estimatedPoses.(['frame' num2str(frameID)]).L1=L1e;
        estimatedPoses.(['frame' num2str(frameID)]).L2=L2e;
%         estimatedPoses.(['frame' num2str(frameID)]).Ninliers=Ninliers;
        estimatedPoses.(['frame' num2str(frameID)]).fitness=fitness;
%         estimatedPoses.(['frame' num2str(frameID)]).dc=dc;
%         estimatedPoses.(['frame' num2str(frameID)]).anglebco=anglebco;
        estimatedPoses.(['frame' num2str(frameID)]).ProcessingTime=ProcessingTime;

end

