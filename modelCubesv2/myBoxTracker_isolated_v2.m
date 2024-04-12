function estimatedBoxPose=myBoxTracker_isolated_v2(estimationsPlanesFileName,...
    sessionID, evalPath, th_angle_deg,conditionalAssignationFlag,...
    compensateHeight, pkFlag)
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
%         [group_tpp, group_tp, group_s]=firstGrouping(globalPlanes, ...
%         th_angle_deg, conditionalAssignationFlag);
    [group_tpp, group_tp, group_s, globalPlanes]=groupSegments(globalPlanes,th_angle_deg,conditionalAssignationFlag);

%     if ~isempty(group_tpp)
%         disp('stop mark')
%     end 
% compute objects
%         globalBoxes=groups2Boxes_isolated(globalPlanes,group_tpp, group_tp, sessionID,...
%             frameID, pkFlag, compensateHeight, th_angle_deg);    
    [boxesFromTriads, remainingGroups]=triads2boxes(globalPlanes,...
                group_tpp,pkFlag,compensateHeight,th_angle_deg,sessionID,frameID);
    if ~isempty(remainingGroups)
        group_tp=[group_tp remainingGroups];
    end
    boxesFromCouples=couples2boxes(globalPlanes, group_tp,pkFlag,...
                compensateHeight, th_angle_deg, sessionID, frameID);
    globalBoxes=[boxesFromTriads boxesFromCouples];

    % eliminate empty box objects
    Ngb=length(globalBoxes);
    indexToEliminate=[];
    for k=1:Ngb
        if globalBoxes(k).id==0
            indexToEliminate=[indexToEliminate k];
        end
    end
    globalBoxes(indexToEliminate)=[];
% ----------debug
%         if mod(i,10)==0
%         if frameID==25
%             disp('stop mark')
%         end 
    
% complement estimated pose and save        
    estimatedBoxPose.(['frame' num2str(frameID)]).values=obj2struct_vector(globalBoxes); 
    estimatedBoxPose.(['frame' num2str(frameID)]).Nnap=estimatedPoses.(['frame' num2str(frameID)]).Nnap;
end
% complement fields

estimatedBoxPose.Parameters.compensateHeight=compensateHeight;
estimatedBoxPose.Parameters.th_angle=th_angle_deg;



% % %% validation figures and texts
% %--- plot global planes
% syntheticPlaneType=4;
% dataSetPath=computeReadPaths(sessionID);
% figure,
% plotEstimationsByFrame_vcuboids_2(globalPlanes.values,syntheticPlaneType,...
%     dataSetPath,sessionID,frameID)
% %--- plot detected boxes vs gt boxes
% fc='b';
% linecolor='w';% color for detections
% figure,
%     myPlotBoxContour_v2(globalBoxes,sessionID,frameID,fc,linecolor)
% %--- plot groups of planes after modify its properties
% 
% % next vectors are couples and triads returned after...
% myDisplayGroups(globalPlanes.values, group_tpp, group_tp, group_s);
% % frameID_v=[0 19 0 25    25 25 	0 	25	23	25 25	25	25	25];
% % planeID_v=[5 10 4 2     2	3 	7 	8 	14	12	5	4	7	11];
% frameID_v=[13 19 20];
% planeID_v=[9 11  18];
% frameFlag=1;
% Nindx=length(frameID_v);
% index=zeros(Nindx,1);
% for i=1:Nindx
% 		index(i) = extractIndexFromIDs(globalPlanes.values,frameID_v(i),planeID_v(i));
% end
% 
% figure,
%     myPlotPlanes_v3(globalPlanes.values(index),frameFlag);
%     title(['local planes  in frame ' num2str(frameID-1)])
end


