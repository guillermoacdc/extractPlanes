function [x, y, z, planeType] = computeBoundingPlane(xp, yp, zp, A, B, C, D, myTolerance)
%COMPUTEBOUNDINGPLANE Summary of this function goes here
%   Detailed explanation goes here
% output: 
% planeType   0: parallel, 1: perpendicular, 2: non-expected

myTol=myTolerance*pi/180;
% compute angle between normal of plane and normal of ground
alpha=computeAngleBtwnVectors([A B C],[0 1 0]);
% alpha=computeAngleBtwnVectors([A B C],[0 0 1]);

if( abs(cos(alpha*pi/180)) > cos (myTol))
    planeType=0;
    disp("parallel to ground plane")
    x=[min(xp) max(xp) ; min(xp) max(xp)];
    z=[min(zp) min(zp); max(zp) max(zp) ];
    y= -1/B*(A*x + C*z + D);
elseif (abs(cos(alpha*pi/180))< cos (pi/2-myTol) )
    disp("perpendicular to ground plane")
    planeType=1;
    devx=std(xp);
    devz=std(zp);
    if (devx>=devz)
        x=[min(xp) max(xp) ; min(xp) max(xp)];
        y=[min(yp) min(yp); max(yp) max(yp) ];
        z = -1/C*(A*x + B*y + D); % Solve for z data
    else
        y=[min(yp) max(yp) ; min(yp) max(yp)];
        z=[min(zp) min(zp); max(zp) max(zp) ];
        x= -1/A*(B*y + C*z + D);
    end
    
else
    planeType=2;
    disp("non expected plane")
    x=[min(xp) max(xp) ; min(xp) max(xp)];
    z=[min(zp) min(zp); max(zp) max(zp) ];
    y= -1/B*(A*x + C*z + D);
end

end

