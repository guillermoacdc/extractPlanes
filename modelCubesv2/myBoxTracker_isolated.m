function estimatedBoxPose=myBoxTracker_isolated(estimationsPlanesFileName,...
    sessionID, evalPath, th_angle_deg,conditionalAssignationFlag,compensateHeight, pkFlag)
% MYBOXTRACKER  Tracks the pose of boxes in consolidation zone
% The outputs are returned in the struct estimatedBoxPose
% The inputs are used to load a etimatedPlanePose file and to parametrize
% the box estimation

estimatedPoses = loadEstimationsFile(estimationsPlanesFileName,sessionID, evalPath);
keyframes=estimatedPoses.keyFrames;
Nframes=length(keyframes);
%% iterative processing
% performing the computation for each frame
for i=1:Nframes
    %% extract global planes at frameID
    frameID=keyframes(i);
    disp(['          processing frame ' num2str(frameID) ' - ' num2str(i) '/' num2str(Nframes)])
    globalPlanes=estimatedPoses.(['frame' num2str(frameID)]).values;   
    %% conform boxes
        %    group planes
        [group_tpp, group_tp, group_s]=firstGrouping(globalPlanes, ...
        th_angle_deg, conditionalAssignationFlag);
        % compute objects
%         globalBoxes=computeBoxesFromGroups(globalPlanes,group_tpp, group_tp, group_s, sessionID, frameID, pkFlag);
        globalBoxes=groups2Boxes_isolated(globalPlanes,group_tpp, group_tp, sessionID,...
            frameID, pkFlag, compensateHeight, th_angle_deg);    

        % ----------debug
        if mod(i,10)==0
%         if frameID==12
            disp('stop mark')
        end 
    
        % complement estimated pose and save        
    estimatedBoxPose.(['frame' num2str(frameID)]).values=obj2struct_vector(globalBoxes); 
    estimatedBoxPose.(['frame' num2str(frameID)]).Nnap=estimatedPoses.(['frame' num2str(frameID)]).Nnap;
end
% complement fields

estimatedBoxPose.Parameters.compensateHeight=compensateHeight;
estimatedBoxPose.Parameters.th_angle=th_angle_deg;
% validation figures and texts
syntheticPlaneType=4;
dataSetPath=computeReadPaths(sessionID);
fc='b';
myDisplayGroups(globalPlanes.values, group_tpp, group_tp, group_s);
figure,
plotEstimationsByFrame_vcuboids_2(globalPlanes.values,syntheticPlaneType,...
    dataSetPath,sessionID,frameID)

figure,
    myPlotBoxContour_v2(globalBoxes,sessionID,frameID,fc)
end


