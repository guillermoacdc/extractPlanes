function [detectionByFrameObj_h, detectionByFrameDescriptor]=computeDetectionIndex_v4(scene,...
    rootPath,processedScenesPath,planeType,mxSearchFrame,boxID)
% computeDetectionIndex_v3 This function returns the plane objects that
% matchs with a plane_gt. The output is composed by two main variables:
% 1. detectionByFrameObj_h. Is a vector with a set of plane objects all
% referenced to the h-world
% 2. detectionByFrameDescriptor. A descriptor of the output with the next
% fields> keyframe, planeID, detectionFlag, distanceToCamera, rotation error btwn plane and camera frames

keyframes=loadKeyFrames(rootPath,scene);
indexMxSearchFrame=find(keyframes==mxSearchFrame);


N=size(keyframes,2);

detectionByFrameDescriptor=zeros(N,8);%keyframe, planeID, detectionFlag, distanceToCamera, rotation error btwn plane and camera frames, alpha, beta, gamma 
k=1;
[reposFlag,reposFrame] = isRepositioned(rootPath,scene,boxID);
% compute plane ground truth for frame 0
planesDescriptors_gt=convertPK2PlaneObjects_v2(rootPath,scene,planeType,0);
plane_gt=extractPlaneByBoxID(planesDescriptors_gt,boxID);

for i=1:indexMxSearchFrame
    frame=keyframes(i);
    display(['computing index in frame ' num2str(frame) ])

    if (reposFlag & frame>=reposFrame)
        planesDescriptors_gt=convertPK2PlaneObjects_v2(rootPath,scene,planeType,reposFrame);
        plane_gt=extractPlaneByBoxID(planesDescriptors_gt,boxID);
        reposFlag=false;     %assumes one reposition as the maximum number of repositions for all scenes
    end

    planesEstimated=detectPlanes(rootPath,scene,frame,processedScenesPath);
    [xzPlanes, xyPlanes, zyPlanes] =extractTypes(planesEstimated,planesEstimated.(['fr' num2str(frame)]).acceptedPlanes); 
%     match based on plane type
    switch planeType
        case 0
            [planeID,flag] = match(xzPlanes,planesEstimated,plane_gt,scene,rootPath);
        case 1
            [planeID,flag] = match(xyPlanes,planesEstimated,plane_gt,scene,rootPath);
        case 2
            [planeID,flag] = match(zyPlanes,planesEstimated,plane_gt,scene,rootPath);
    end
    
    if ~isempty(planeID)
        detectionByFrameObj_h(k)=planesEstimated.(['fr' num2str(frame)]).values(planeID);
        k=k+1;
        [distanceToCamera, er, alpha, beta, gamma]=computeDistanceToCamera(planesEstimated,[frame planeID]);

        detectionByFrameDescriptor(i,:)=[frame, planeID, flag,...
            distanceToCamera, er, alpha, beta, gamma];

    else
        detectionByFrameDescriptor(i,1)=frame;
        detectionByFrameDescriptor(i,3)=flag;
    end
end
sumDetectionFlag=sum(detectionByFrameDescriptor(:,3));
if sumDetectionFlag==0
    detectionByFrameObj_h=[];
end

end