% pseudocode source: https://giou.stanford.edu/
function [IOU] = computeIOU(A,B)
%COMPUTEIOU Computes the IoU of two rectangles (A, B) represented 
% parametrically by their bottom-left corner (x1,y1) and their
% top-right corner (x2,y2)
% Assumptions.  The rectangle is 2D 
%               The rectangle is oriented along main axis x, y

% 1. Ensure that A.x2>A.x1, and A.y2>A.y1
A.x1e=min(A.x1,A.x2);
A.x2e=max(A.x1,A.x2);
A.y1e=min(A.y1,A.y2);
A.y2e=max(A.y1,A.y2);

% 2. compute area of A and B
A.area=(A.x2e-A.x1e)*(A.y2e-A.y1e);
B.area=(B.x2-B.x1)*(B.y2-B.y1);
% 3. compute the intersection I between A and B
I.x1=max(A.x1e,B.x1);
I.x2=min(A.x2e,B.x2);
I.y1=max(A.y1e,B.y1);
I.y2=min(A.y2e,B.y2);
if (I.x2>I.x1) & (I.y2>I.y1)
    I.area=(I.x2-I.x1)*(I.y2-I.y1);
else
    I.area=0;
end
% 4. compute the IoU
IOU=I.area/(A.area+B.area-I.area);


end

