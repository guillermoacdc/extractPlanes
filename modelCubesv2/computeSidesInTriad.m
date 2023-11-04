function side = computeSidesInTriad(globalPlanes,indextop, indexperp)
%COMPUTESIDESINTRIAD Computes the side of perpendicular plane. The side is in range
% 1. for plane located in the positive direction of ztop
% 2. for plane located in the positive direction of xtop
% 3. for plane located in the negative direction of ztop
% 4. for plane located in the negative direction of xtop 
%   Detailed explanation goes here
th_angle=18;%update passing this variable as input argument

[~,er]=computeSinglePoseError(globalPlanes(indextop).tform,...
    globalPlanes(indexperp).tform);

if er<th_angle
    side=1;
else

%     logic comparison
if er<th_angle
    side=1;
else
    if er>=180-th_angle
        side=3;
    else
        if globalPlanes(indexperp).D>globalPlanes(indextop).D
            side=2;
        else
            side=4;
        end
    end
end

end

