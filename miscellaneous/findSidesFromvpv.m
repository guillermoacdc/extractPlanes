function sides = findSidesFromvpv(visiblePlanesVector,boxID)
%FINDSIDESFROMVPV Find sides of each boxID from a visiblePlanesVector
%   Detailed explanation goes here
indexes=find(visiblePlanesVector(:,1)==boxID);
N=length(indexes);
sides=[];
for i=1:N
    side=visiblePlanesVector(indexes(i),2);
    sides=[sides side];
end
end

