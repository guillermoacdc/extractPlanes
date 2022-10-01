function [detectionByFrameObj_h, detectionByFrameDescriptor]=computeDetectionIndex_v3(plane_gt,scene,rootPath,planeType,mxSearchFrame)
% computeDetectionIndex_v3 This function returns the plane objects that
% matchs with a plane_gt. The output is composed by two main variables:
% 1. detectionByFrameObj_h. Is a vector with a set of plane objects all
% referenced to the h-world
% 2. detectionByFrameDescriptor. A descriptor of the output with the next
% fields> keyframe, planeID, detectionFlag, distanceToCamera, rotation error btwn plane and camera frames

keyframes=loadKeyFrames(rootPath,scene);
indexMxSearchFrame=find(keyframes==mxSearchFrame);
% removing keyframe24 in scene 6 until tracking of bug
if scene==6
    [~,ikf24]=find(keyframes==24);
    keyframes(ikf24)=[];
    [~,ikf70]=find(keyframes==70);
    keyframes(ikf70)=[];
    indexMxSearchFrame=indexMxSearchFrame-2;
end

N=size(keyframes,2);

detectionByFrameDescriptor=zeros(N,8);%keyframe, planeID, detectionFlag, distanceToCamera, rotation error btwn plane and camera frames, alpha, beta, gamma 
k=1;

for i=1:indexMxSearchFrame
    
    frame=keyframes(i);
    display(['computing index in frame ' num2str(frame) ])
    planesEstimated=detectPlanes(rootPath,scene,frame);
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