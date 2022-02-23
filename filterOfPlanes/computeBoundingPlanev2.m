function [x, y, z] = computeBoundingPlanev2(planeDescriptor)
%COMPUTEBOUNDINGPLANE Summary of this function goes here
%   Detailed explanation goes here
% output: 
% planeType   0: parallel, 1: perpendicular, 2: non-expected

% myTol=myTolerance*pi/180;
% compute angle between normal of plane and normal of ground
% alpha=computeAngleBtwnVectors([A B C],[0 1 0]);
% alpha=computeAngleBtwnVectors([A B C],[0 0 1]);

if( planeDescriptor.type==0)%"parallel to ground plane"
    
    x=[planeDescriptor.limits(1) planeDescriptor.limits(2) ; planeDescriptor.limits(1) planeDescriptor.limits(2)];
    z=[planeDescriptor.limits(5) planeDescriptor.limits(5); planeDescriptor.limits(6) planeDescriptor.limits(6) ];
    y= -1/planeDescriptor.B*(planeDescriptor.A*x + planeDescriptor.C*z + planeDescriptor.D);
elseif (planeDescriptor.type==1)%"perpendicular to ground plane"
    if (planeDescriptor.planeTilt==1)%x-y tilt
        x=[planeDescriptor.limits(1) planeDescriptor.limits(2) ; planeDescriptor.limits(1) planeDescriptor.limits(2)];
        y=[planeDescriptor.limits(3) planeDescriptor.limits(3); planeDescriptor.limits(4) planeDescriptor.limits(4) ];
        z = -1/planeDescriptor.C*(planeDescriptor.A*x + planeDescriptor.B*y + planeDescriptor.D); % Solve for z data
    else%z-y tilt
        y=[planeDescriptor.limits(3) planeDescriptor.limits(4) ; planeDescriptor.limits(3) planeDescriptor.limits(4)];
        z=[planeDescriptor.limits(5) planeDescriptor.limits(5); planeDescriptor.limits(6) planeDescriptor.limits(6) ];
        x= -1/planeDescriptor.A*(planeDescriptor.B*y + planeDescriptor.C*z + planeDescriptor.D);
    end
    
else%"non expected plane" --- must be recomputed
    x=[planeDescriptor.limits(1) planeDescriptor.limits(2) ; planeDescriptor.limits(1) planeDescriptor.limits(2)];
    z=[planeDescriptor.limits(5) planeDescriptor.limits(5); planeDescriptor.limits(6) planeDescriptor.limits(6) ];
    y= -1/planeDescriptor.B*(planeDescriptor.A*x + planeDescriptor.C*z + planeDescriptor.D);
end

end

