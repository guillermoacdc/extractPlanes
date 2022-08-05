function [keyPlaneTwins] = trackKeyPlane(keyPlaneID,localPlanes,frames)
%TRACKKEYPLANE Summary of this function goes here
% Load all ids from top planes
% Seek key plane twins based on similarity thresholds over a set of features 
% of segment of planes

keyPlaneTwins=[];
keyPlaneP=loadPlanesFromIDs(localPlanes,keyPlaneID);
Nf=size(frames,2);
for i=1:Nf
    frame=frames(i);
    [xzPlanes,~,~]=extractTypes(localPlanes, localPlanes.(['fr' num2str(frame)]).acceptedPlanes);
    Np=size(xzPlanes,1);
    for j=1:Np
        disp("processing candidate " + num2str(xzPlanes(j,1))+"-"+num2str(xzPlanes(j,2)));
        candidateP=loadPlanesFromIDs(localPlanes,xzPlanes(j,:));
        type=computeTypeOfTwin(keyPlaneP,candidateP);
        if type==1
            keyPlaneTwins=[keyPlaneTwins; xzPlanes(j,:)];
        end
    end
end
end

