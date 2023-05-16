function [L1,L2] = computeL1L2FromPK(boxLengths,planeType)
%COMPUTEPLANELENGTHSFROMGTBOX Computes the lengths (L1,L2) of a plane from
%two inputs: the box length (h,w,d) and the planeType: (0: top planes; 
% 1: front and back planes; 2: lateral planes)
%   Detailed explanation goes here
height=boxLengths(2);
width=boxLengths(3);
depth=boxLengths(4);

switch planeType
    case 0
            L1=min(width,depth);
            L2=max(width,depth);
    case 1
            L1=min(height,depth);
            L2=max(height,depth);
    case 2
            L1=min(height,width);
            L2=max(height,width);
    

end

end

