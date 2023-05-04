function [d1,d2] = computeDistanceBtwnPlanes(planeA,planeB)
%UNTITLED compute distance between two models of planes 
%   d1: distance in 3D space
% d2: distance in the coplanar axis
% assumption. the two planes at input are coplanar

% compute d1
d1=norm(planeA.geometricCenter-planeB.geometricCenter);
% compute d2
if planeA.type==0
    d2=abs(planeA.geometricCenter(2)-planeB.geometricCenter(2));
else
    if (planeA.planeTilt==0)
        d2=abs(planeA.geometricCenter(1)-planeB.geometricCenter(1));
    else
        d2=abs(planeA.geometricCenter(3)-planeB.geometricCenter(3));
    end
end

end

