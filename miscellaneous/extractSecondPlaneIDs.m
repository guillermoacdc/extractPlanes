function [secondPlaneIDs, thirdPlaneIDs] = extractSecondPlaneIDs(globalPlanes)
%EXTRACTSECONDPLANEIDS Summary of this function goes here
%   Detailed explanation goes here
secondPlaneIDs=[];
thirdPlaneIDs=[];
Np=length(globalPlanes);
for i=1:Np
    plane=globalPlanes(i);
    if ~isempty(plane.secondPlaneID)
        secondPlaneIDs=[secondPlaneIDs i];
    end
    if ~isempty(plane.thirdPlaneID)
        thirdPlaneIDs=[thirdPlaneIDs i];
    end
end
end

