function [closestPlaneID, index] = computeSingleNeighborhoodPlane(targetPlane,searchSpace,planeDescriptor)
%COMPUTEPLANENEIGHBORHOOD Compuste closest plane ID wrt targetPlane,
%performing a search in the searchSpace vector
%   Detailed explanation goes here

closestPlaneID=[];
closestDistance=realmax;
N=length(searchSpace);

for i=1:N
    currentDistance=norm(targetPlane.geometricCenter-searchSpace(i).geometricCenter);
    if currentDistance<closestDistance
        closestDistance=currentDistance;
        closestPlaneID=searchSpace(i).idPlane;
        index=i;
    end
end

end

