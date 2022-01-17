function [x y z flag] = createPlaneFromModel_v2(xp, yp, zp, A, B, C, D, groundD)
%CREATEPLANEFROMMODEL Summary of this function goes here
%   Detailed explanation goes here
% script created for point clouds with height in y axis 
x=0;
y=0;
z=0;


% compute angle between normal of plane and normal of ground
alpha=computeAngleBtwnVectors([A B C],[0 1 0]);
ctrl=abs(cos(alpha*pi/180));
e=0.3;%tolerance of parallel/perpendicular planes
flag=0;

% % set a flag when the plane belongs to ground
if (abs(groundD-D)<0.15)
    flag=1;
end

% case for (1) parallel planes, (2) perpendicular planes
if(ctrl<e)
    disp("perpendicular to ground plane")
    x=[min(xp) max(xp) ; min(xp) max(xp)];
    y=[min(yp) min(yp); max(yp) max(yp) ];
    z = -1/C*(A*x + B*y + D); % Solve for z data
    flag=1;
elseif(ctrl>(1-e))
    disp("parallel to ground plane")
    x=[min(xp) max(xp) ; min(xp) max(xp)];
    z=[min(zp) min(zp); max(zp) max(zp) ];
    y= -1/B*(A*x + C*z + D);
else
    disp("undetermined orientation")
	%this code must be updated
    y=[min(yp) max(yp) ; min(yp) max(yp)];
    z=[min(zp) min(zp); max(zp) max(zp) ];
    x= -1/A*(B*y + C*z + D);
end


        

end

