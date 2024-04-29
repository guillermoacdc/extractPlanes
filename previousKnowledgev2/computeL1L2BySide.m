function [L1,L2] = computeL1L2BySide(myBox,sideID)
%COMPUTEPLANELENGTHSFROMGTBOX Computes the lengths (L1,L2) of a plane from
%two inputs: the box length (h,w,d) and the planeType: (0: top planes; 
% 1: front and back planes; 2: lateral planes)
%   Detailed explanation goes here

switch sideID
    case 0
            L1=min(myBox.width,myBox.depth);
            L2=max(myBox.width,myBox.depth);
    case 2
            L1=min(myBox.height,myBox.depth);
            L2=max(myBox.height,myBox.depth);
    case 1
            L1=min(myBox.height,myBox.width);
            L2=max(myBox.height,myBox.width);
    case 3
            L1=min(myBox.height,myBox.width);
            L2=max(myBox.height,myBox.width);        
    case 4
            L1=min(myBox.height,myBox.depth);
            L2=max(myBox.height,myBox.depth);

end

end

