function [detectionByFrameObj_h, detectionByFrameDescriptor]=computeDetectionIndex(plane_gt,scene,rootPath)


% rootPath="C:\lib\boxTrackinPCs\";
% scene=5;
% boxID=15;
% planesDescriptors_gt=convertPK2PlaneObjects(rootPath,scene);
% plane_gt=extractPlaneByBoxID(planesDescriptors_gt,boxID);

keyframes=loadKeyFrames(rootPath,scene);
% removing keyframe24 in scene 6 until tracking of bug
[~,ikf24]=find(keyframes==24);
keyframes(ikf24)=[];
[~,ikf70]=find(keyframes==70);
keyframes(ikf70)=[];


N=size(keyframes,2);

detectionByFrameDescriptor=zeros(N,3);
k=1;

for i=1:N
    display(['computing index in frame ' num2str(keyframes(i)) ])
    frame=keyframes(i);
%     if frame==24
%         disp 'stop';
%     end
    planesEstimated=detectPlanes(rootPath,scene,frame);
    topPlanesEstimated=extractTypes(planesEstimated,planesEstimated.(['fr' num2str(frame)]).acceptedPlanes); 
    [planeID,flag] = match(topPlanesEstimated,planesEstimated,plane_gt,scene,rootPath);
    if ~isempty(planeID)
        detectionByFrameObj_h(k)=planesEstimated.(['fr' num2str(frame)]).values(planeID);
%         T_m(k,:)=T;
        k=k+1;
        detectionByFrameDescriptor(i,:)=[frame planeID flag];
    else
        detectionByFrameDescriptor(i,1)=frame;
        detectionByFrameDescriptor(i,3)=flag;
    end


end