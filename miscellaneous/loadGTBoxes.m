function gtBoxes= loadGTBoxes(sessionID,frameID)
%LOADGTBOXES Loads a vector of box objects with the descriptors of boxes in
%the consolidation zone at an specific frame
%   Detailed explanation goes here


dataSetPath=computeReadPaths(sessionID);
% load initial pose
initialPose=loadInitialPose(dataSetPath, sessionID, frameID);
% extract id of boxes and compute number of boxes
boxesID=initialPose(:,1);
Nb=length(boxesID);
% load box lengths
boxLengths=loadLengths_v2(dataSetPath, boxesID);%IdBox,Heigth(mm),Width(mm),Depth(mm)
% assemble the gtBoxes vector
for i=1:Nb
    tform=assemblyTmatrix(initialPose(i,2:end));
%     tform(1:3,4)=tform(1:3,4)*1000;%convert from m to mm
    heigth=boxLengths(i,2);
    width=boxLengths(i,3);
    depth=boxLengths(i,4);
    boxID=boxesID(i);
    gtBoxes(i)=detectedBox(boxID, depth, heigth, width, tform, [], []);
end


end

