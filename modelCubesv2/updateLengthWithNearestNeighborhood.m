function [width, depth, height, boxID]=updateLengthWithNearestNeighborhood(estimatedLength, sessionID, frameID)
% perform a search of the nearest point btwn searchspace and estimatedLength vector;
% estimatedLength vector is in sequence [width, depth, height]

%% load searchspace
dataSetPath=computeReadPaths(sessionID);
pps = getPPS(dataSetPath,sessionID, frameID);
parameters =loadLengths_v2(dataSetPath,pps);%boxID H, W, D in mm
% reorder lengths to complain id, width, depth, height
searchSpace=parameters(:,[1,3,4,2]);

%% select the nearest element in search space
Nb=size(parameters,1);
distanceVector=zeros(Nb,1);
% compute distance
for i=1:Nb
    distanceVector(i)=norm(searchSpace(i,2:4)-estimatedLength);
end
[~, index]=min(distanceVector);

boxID=searchSpace(index,1);
% update length
width=searchSpace(index,2);
depth=searchSpace(index,3);
height=searchSpace(index,4);
end