function As = geometricCenterLength2corners(A)
%geometricCenterLENGTH2CORNERS Converts a plane from parameters (geometric center, L1, L2)
% to corner parameters (x1, y1, x2, y2); with (x1,y1) in the lower left
% corner and (x2,y2) in the higher right corner. Returns an struct with
% four fields corresponding to x1, y1, x2, y2.
%   Assumptions: The plane is type 1: perpendicular plane
%                 The plane is oriented with the axis of main frame

if A.planeTilt
    if A.L2toY
%         set 1
        As.x1=A.geometricCenter(1)-A.L1/2;
        As.x2=A.geometricCenter(1)+A.L1/2;
        As.y1=A.geometricCenter(2)-A.L2/2;
        As.y2=A.geometricCenter(2)+A.L2/2;
    else
        As.x1=A.geometricCenter(1)-A.L2/2;
        As.x2=A.geometricCenter(1)+A.L2/2;
        As.y1=A.geometricCenter(2)-A.L1/2;
        As.y2=A.geometricCenter(2)+A.L1/2;
    end
else
    if A.L2toY
        As.x1=A.geometricCenter(3)-A.L1/2;
        As.x2=A.geometricCenter(3)+A.L1/2;
        As.y1=A.geometricCenter(2)-A.L2/2;
        As.y2=A.geometricCenter(2)+A.L2/2;
    else
        As.x1=A.geometricCenter(3)-A.L2/2;
        As.x2=A.geometricCenter(3)+A.L2/2;
        As.y1=A.geometricCenter(2)-A.L1/2;
        As.y2=A.geometricCenter(2)+A.L1/2;
end

end

