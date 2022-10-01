function [L1,L2] = computePlaneLengthsFromGTBox(boxLengths,planeType)
%COMPUTEPLANELENGTHSFROMGTBOX Computes the lengths (L1,L2) of a plane from
%two inputs: the box length (h,w,d) and the planeType: (0 top ,1 xz,2 yz)
%   Detailed explanation goes here
height=boxLengths(1);
width=boxLengths(2);
depth=boxLengths(3);

switch planeType
    case 0
            L1=min(width,depth);
            L2=max(width,depth);
    case 2
            L1=min(height,width);
            L2=max(height,width);
    case 1
            L1=min(height,depth);
            L2=max(height,depth);

end

end

