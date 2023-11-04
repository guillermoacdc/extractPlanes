function [secondPlaneIDs, thirdPlaneIDs] = extractSecondAndThirdPlaneIDs(globalPlanes)
%EXTRACTSECONDPLANEIDS Summary of this function goes here
%   Detailed explanation goes here
secondPlaneIDs=[];
thirdPlaneIDs=[];
Np=length(globalPlanes);
for i=1:Np
    plane=globalPlanes(i);
    if ~isempty(plane.secondPlaneID)
        secondPlaneIDs=[secondPlaneIDs plane.secondPlaneID];
    end
    if ~isempty(plane.thirdPlaneID)
        thirdPlaneIDs=[thirdPlaneIDs plane.thirdPlaneID];
    end
end
end

