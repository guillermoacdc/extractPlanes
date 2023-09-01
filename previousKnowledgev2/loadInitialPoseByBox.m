function [Tm2b] = loadInitialPoseByBox(boxID,sessionID,frameID)
%LOADINITIALPOSEBYBOX Summary of this function goes here
%   Detailed explanation goes here
dataSetPath=computeMainPaths(sessionID);
initPose_m=loadInitialPose(dataSetPath,sessionID,frameID);
indexBox=find(initPose_m(:,1)==boxID);
initPose=initPose_m(indexBox,2:end);
Tm2b=assemblyTmatrix(initPose);
end

