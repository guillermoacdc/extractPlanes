function closestDistance=computeNeighborhoodPlanes(targetPlane,...
    searchSpace,planeDescriptor)
%COMPUTENEIGHBORHOODPLANES Computes the two nearest neighborhood planes and
%store its id in the planeDescriptor fields with name> nearestPlaneID,
%secondNearestPlaneID. Returns the distance to the closest plane in mt

[closestPlane, index, closestDistance]=computeSingleNeighborhoodPlane(targetPlane,...
    searchSpace,planeDescriptor);
searchSpace(index,:)=[];
[secondClosestPlane]=computeSingleNeighborhoodPlane(targetPlane,...
    searchSpace,planeDescriptor);

planeDescriptor.(['fr' num2str(targetPlane(1))]).values(targetPlane(2)).nearestPlaneID=closestPlane;
planeDescriptor.(['fr' num2str(targetPlane(1))]).values(targetPlane(2)).secondNearestPlaneID=secondClosestPlane;

end

