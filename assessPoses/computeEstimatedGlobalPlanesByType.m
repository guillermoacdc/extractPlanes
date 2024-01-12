function globalPlanes=computeEstimatedGlobalPlanesByType(estimatedPlanes,planeType, frameID);
%COMPUTEESTIMATEDGLOBALPLANESBYTYPE Extract a subset from vector
%estimatedPlanes, based on the value of planeType

%load estimations in the current frame
if planeType==0
    index=estimatedPlanes.(['frame' num2str(frameID)]).values.xzIndex;
else
    index1=estimatedPlanes.(['frame' num2str(frameID)]).values.xyIndex;
    index2=estimatedPlanes.(['frame' num2str(frameID)]).values.zyIndex;
    index=[index1; index2];
end
if isempty(index)
    globalPlanes=[];
else
    globalPlanes.values=estimatedPlanes.(['frame' num2str(frameID)]).values.values(index);
    globalPlanes.Nnap=estimatedPlanes.(['frame' num2str(frameID)]).Nnap;            
end
end

