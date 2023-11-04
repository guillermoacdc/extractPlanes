function searchSpace = setdiff_v2(acceptedPlanes,targetPlane)
%SETDIFF_V2 returns the elements of acceptedPlanes that are not present in
%the vector targetPlane.
%   Detailed explanation goes here

if isempty(acceptedPlanes)
    searchSpace=[];
else
    if isempty(targetPlane)
        searchSpace=acceptedPlanes;
    else
        TacceptedPlanes=table(acceptedPlanes(:,1), acceptedPlanes(:,2));
        TtargetPlane=table(targetPlane(:,1), targetPlane(:,2));
        [~, b]=setdiff(TacceptedPlanes,TtargetPlane);
        searchSpace=acceptedPlanes(b,:);
    end
end

end

