function [closestPlaneID, index, closestDistance] = computeSingleNeighborhoodPlane(targetPlane,searchSpace,planeDescriptor)
%COMPUTEPLANENEIGHBORHOOD Compuste closest plane ID wrt targetPlane,
%performing a search in the searchSpace vector
%   Detailed explanation goes here

closestPlaneID=[];
closestDistance=realmax;
N=size(searchSpace,1);

for i=1:N
    targetPlaneValue=planeDescriptor.(['fr' num2str(targetPlane(1))]).values(targetPlane(2)).geometricCenter;
    candidateValue=planeDescriptor.(['fr' num2str(searchSpace(i,1))]).values(searchSpace(i,2)).geometricCenter;
    currentDistance=norm(targetPlaneValue-candidateValue);
    if currentDistance<closestDistance
        closestDistance=currentDistance;
        closestPlaneID=planeDescriptor.(['fr' num2str(searchSpace(i,1))]).values(searchSpace(i,2)).getID;
        index=i;
    end
end

end

