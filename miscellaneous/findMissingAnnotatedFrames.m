function missingFrames = findMissingAnnotatedFrames(sessionID)
%FINDMISSINGANNOTATEDFRAMES Summary of this function goes here
%   Detailed explanation goes here


missingFrames=[];
%% load visible planes by session
fileName='visiblePlanesByFrame.json';
visiblePlanesBySession = loadVisiblePlanesBySession(fileName,sessionID);
% load keyframes annotated
properties=fieldnames(visiblePlanesBySession);
Np=length(properties);
old='frame';
new='';
keyFrames=zeros(Np,1);
for i=1:Np
    frameName=string(properties{i});
    frameID_str = replace(frameName,old,new);
    keyFrames(i)=str2num( frameID_str );
end
% load reference keyframes
dataSetPath=computeMainPaths(sessionID);
keyframes_ref=loadKeyFrames(dataSetPath, sessionID);
missingFrames=setdiff(keyframes_ref,keyFrames);
end

